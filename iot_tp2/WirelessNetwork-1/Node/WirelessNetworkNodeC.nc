/*
	Component File - definition (implementation) of the component
*/

#include "WirelessNetworkMsg1.h"
#include "WirelessNetworkMsg2.h"
#include "WirelessNetworkMsg3.h"
#include "WirelessNetworkMsg4.h"
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
	message_t pkt;
	uint16_t versionID = 0;
	am_addr_t parentNode;
	uint16_t temperatureVal;
	uint16_t lumVal;
	
	// Use LEDs to report various status issues.
	void report_received() { call Leds.led0Toggle(); }
	void report_broadcast() { call Leds.led1Toggle(); }
	void report_reponse() { call Leds.led2Toggle(); }


	event void Boot.booted(){
		call Leds.led1On();	
		call RadioControl.start();  //initializing radios
	}

	event void RadioControl.startDone(error_t err) {
		if(err != SUCCESS) {
			report_received();
			call RadioControl.start();
		}
	}

	event void RadioControl.stopDone(error_t err) { } // do nothing

	task void respondTopoReq()	{
		message_t output;
		WirelessNetworkPayloadMsg2* topoReq = (WirelessNetworkPayloadMsg2*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg2));
		topoReq->pl_idMsg = versionID;
		topoReq->pl_parentNode = parentNode;
		topoReq->pl_originNode = TOS_NODE_ID;

		if(call	AMS2.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg2)) != SUCCESS)
			post respondTopoReq();
		else
			report_reponse();
	}

	task void respondSensorReq()	{
		message_t output;
		WirelessNetworkPayloadMsg4* sensorReq = (WirelessNetworkPayloadMsg4*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg4));
		
		//Tenta pegar os dados dos sensores
		call Luminosity.read();
		call Temperature.read();

		sensorReq->pl_idMsg = versionID;
		sensorReq->pl_LumData = lumVal;
		sensorReq->pl_TempData = temperatureVal;
		sensorReq->pl_Origin  = TOS_NODE_ID;
		//sensorReq-> extra_data[0] =  time(NULL); //timestamp
		
		if(call	AMS4.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg4)) != SUCCESS)
			post respondSensorReq();
		else
			report_reponse();
	}

	
	void forwardTopoReq(void* payload){
				
		if(call	AMS1.send(AM_BROADCAST_ADDR,	payload, sizeof(WirelessNetworkPayloadMsg2)) != SUCCESS)
			forwardTopoReq(payload);
		else
			report_broadcast();
		// se der errado, trocar a msg output por sendTopoReq
		
	}

	void forwardSensorReq(void* payload){
		
		if(call	AMS3.send(parentNode,	payload, sizeof(WirelessNetworkPayloadMsg4)) != SUCCESS)
			forwardTopoReq(payload);		
		else
			report_broadcast();
	}

	event message_t* AMR1.receive(message_t* msg, void* payload, uint8_t len) {
		am_id_t type = call AMPacket.type(msg);


		if (type == AM_WIRELESSNETWORKPAYLOADMSG1 && len == sizeof(WirelessNetworkPayloadMsg1)) {

			WirelessNetworkPayloadMsg1* req = (WirelessNetworkPayloadMsg1*) payload;

			if (req->pl_idMsg > versionID) {
				report_received();
				parentNode = call AMPacket.source(msg);
				versionID = req->pl_idMsg;
				respondTopoReq();
			}
		}

		return msg;
	}
	
	event message_t* AMR2.receive(message_t* msg, void* payload, uint8_t len) {
		am_id_t type = call AMPacket.type(msg);

		if (type == AM_WIRELESSNETWORKPAYLOADMSG2 && len == sizeof(WirelessNetworkPayloadMsg4)){
			WirelessNetworkPayloadMsg4* req	= (WirelessNetworkPayloadMsg4*) payload;
			if (req->pl_idMsg > versionID) {
				versionID = req->pl_idMsg;
				forwardSensorReq(payload);
			}
		}
		return msg;
	}

	event message_t* AMR3.receive(message_t* msg, void* payload, uint8_t len) {
		am_id_t type = call AMPacket.type(msg);

		if (type == AM_WIRELESSNETWORKPAYLOADMSG3 && len == sizeof(WirelessNetworkPayloadMsg3)) {

			WirelessNetworkPayloadMsg3* req	= (WirelessNetworkPayloadMsg3*) payload;

			if (req->pl_idMsg > versionID) {
				report_received();
				versionID = req->pl_idMsg;
				respondSensorReq();
			}

		}
		return msg;
	}

	event message_t* AMR4.receive(message_t* msg, void* payload, uint8_t len) {
		am_id_t type = call AMPacket.type(msg);

		if(type == AM_WIRELESSNETWORKPAYLOADMSG4 && len == sizeof(WirelessNetworkPayloadMsg2)){

			WirelessNetworkPayloadMsg2* req	= (WirelessNetworkPayloadMsg2*) payload;
			if (req->pl_idMsg > versionID) {
				versionID = req->pl_idMsg;
				forwardTopoReq(payload);
			}


		}
		return msg;
	}

	event void AMSend.sendDone(message_t* msg, error_t err)	{
		if(err != SUCCESS){
			am_id_t type = call AMPacket.type(msg);
			if (type == AM_WIRELESSNETWORKPAYLOADMSG1) post	respondTopoReq();
			else if (type == AM_WIRELESSNETWORKPAYLOADMSG3) post respondSensorReq();
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

