/*
	Component File - definition (implementation) of the component
*/

#include "WirelessNetworkMessages.h"

//#include <time.h>

module WirelessNetworkNodeC @safe(){

	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	
	uses interface AMSend as AMS1;
	uses interface AMSend as AMS2;
	uses interface AMSend as AMS3;
	uses interface AMSend as AMS4;
	uses interface Receive as AMR1;
	uses interface Receive as AMR2;
	uses interface Receive as AMR3;
	uses interface Receive as AMR4;

	uses interface SplitControl as RadioControl;
	uses interface Read<uint16_t> as Temperature;
	uses interface Read<uint16_t> as Luminosity;
	uses interface Leds;

}

implementation {

	bool busy = FALSE;
	bool is_response = FALSE;
	message_t pkt;
	message_t broadcast_pkt;
	message_t forward_pkt;
	uint16_t versionID = 0;
	am_addr_t parentNode = 0;
	uint16_t temperatureVal = 0;
	uint16_t lumVal = 0 ;
	
	// Use LEDs to report various status issues.
	//void report_received() { call Leds.led0Toggle(); }
	//void report_broadcast() { call Leds.led1Toggle(); }
	//void report_reponse() { call Leds.led2Toggle(); }
	void report_correctReceive() { call Leds.led1Toggle(); } //green
	void report_correctSend() { call Leds.led2Toggle(); }	//yellow
	void report_correctParentOrBroadcast() { call Leds.led0Toggle(); } //red

	event void Boot.booted(){
		call RadioControl.start();  //initializing radios
		call Leds.led1On();	
	}

	event void RadioControl.startDone(error_t err) {
		if(err != SUCCESS) {
			call Leds.led1On();	
			call RadioControl.start();
		}
	}

	event void RadioControl.stopDone(error_t err) {
	} // do nothing
	
	task void respondTopoReq()	{
		//message_t output;
		WirelessNetworkPayloadMsg2* topoReq = (WirelessNetworkPayloadMsg2*) call Packet.getPayload(&pkt,sizeof(WirelessNetworkPayloadMsg2));
		topoReq->pl_idMsg = versionID;
		topoReq->pl_parentNode = parentNode;
		topoReq->pl_originNode = TOS_NODE_ID;
		is_response = TRUE;
		call AMS2.send(parentNode, &pkt, sizeof(WirelessNetworkPayloadMsg2));
	}

	task void respondSensorReq()	{
		//message_t output;
		WirelessNetworkPayloadMsg4* sensorReq = (WirelessNetworkPayloadMsg4*) call Packet.getPayload(&pkt,sizeof(WirelessNetworkPayloadMsg4));
		
		//Tenta pegar os dados dos sensores
		call Luminosity.read();
		call Temperature.read();
		
		sensorReq->pl_idMsg = versionID;
		sensorReq->pl_LumData = lumVal;
		sensorReq->pl_TempData = temperatureVal;
		sensorReq->pl_Origin  = TOS_NODE_ID;
		//sensorReq-> extra_data[0] =  time(NULL); //timestamp
		is_response = TRUE;
		call AMS4.send(parentNode,	&pkt, sizeof(WirelessNetworkPayloadMsg4));
	}


	task void broadcastTopoReq(){
		WirelessNetworkPayloadMsg1* topoReq = (WirelessNetworkPayloadMsg1*) call Packet.getPayload(&pkt,sizeof(WirelessNetworkPayloadMsg1));				
		topoReq->pl_idMsg = versionID;
		call AMS1.send(AM_BROADCAST_ADDR,	&broadcast_pkt, sizeof(WirelessNetworkPayloadMsg1));
		
	}

	task void broadcastSensorReq(){
		WirelessNetworkPayloadMsg3* sensorReq = (WirelessNetworkPayloadMsg3*) call Packet.getPayload(&pkt, sizeof(WirelessNetworkPayloadMsg3));
		sensorReq->pl_idMsg = versionID;
		call AMS3.send(AM_BROADCAST_ADDR,	&broadcast_pkt, sizeof(WirelessNetworkPayloadMsg3));
		
	}

	task void forwardTopoRes(){
		is_response = FALSE;
		call AMS2.send(parentNode,	&forward_pkt, sizeof(WirelessNetworkPayloadMsg2));
	}

	task void forwardSensorRes(){
		is_response = FALSE;
		call AMS4.send(parentNode,	&forward_pkt, sizeof(WirelessNetworkPayloadMsg4));
	}


	event message_t* AMR1.receive(message_t* msg, void* payload, uint8_t len) {

			WirelessNetworkPayloadMsg1* req = (WirelessNetworkPayloadMsg1*) payload;
			if (req->pl_idMsg > versionID) {
				report_correctReceive();
				parentNode = call AMPacket.source(msg);
				versionID = req->pl_idMsg;
				post respondTopoReq();
				post broadcastTopoReq();
			}

		return msg;
	}
	
	event message_t* AMR2.receive(message_t* msg, void* payload, uint8_t len) {
		post forwardTopoRes();

		return msg;
	}

	event message_t* AMR3.receive(message_t* msg, void* payload, uint8_t len) {

			WirelessNetworkPayloadMsg3* req	= (WirelessNetworkPayloadMsg3*) payload;
			if (req->pl_idMsg > versionID) {
				versionID = req->pl_idMsg;
				post respondSensorReq();
				post broadcastSensorReq();
			}

		return msg;
	}

	event message_t* AMR4.receive(message_t* msg, void* payload, uint8_t len) {
		post forwardSensorRes();
		return msg; 
	}

	event void AMS1.sendDone(message_t* msg, error_t err)	{
		if(err == SUCCESS){
			report_correctSend();		
		} else {
			post broadcastTopoReq();
			report_correctParentOrBroadcast();
		}
	}

	event void AMS2.sendDone(message_t* msg, error_t err)	{
		if(err == SUCCESS){
			report_correctSend();		
		} else {			
			if( is_response ) 
				post respondTopoReq();				
			else 
				post forwardTopoRes(); 
		}
	}

	event void AMS3.sendDone(message_t* msg, error_t err)	{
		if(err == SUCCESS){
			report_correctSend();		
		} else {
			post broadcastSensorReq();
			report_correctSend();
		}
	}

	event void AMS4.sendDone(message_t* msg, error_t err)	{	
		if(err == SUCCESS){
			report_correctSend();		
		} else {
			if( is_response ) 
				post respondSensorReq();				
			else 
				post forwardSensorRes(); 			

		}
	}
	
	event void Temperature.readDone( error_t result, uint16_t val ){
		if(result == SUCCESS){
			temperatureVal = val;
		}
	}
	
	event void Luminosity.readDone( error_t result, uint16_t val ){
		if(result == SUCCESS){
			lumVal = val;
		}
	} 
}


