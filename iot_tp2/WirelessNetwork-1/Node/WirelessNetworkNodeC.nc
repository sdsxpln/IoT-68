/*
	Component File - definition (implementation) of the component
*/

#include "WirelessNetworkMessages.h"
#include <time.h>

module WirelessNetworkC{

	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface Receive;
	uses interface SplitControl as AMControl;
	uses interface Read<uint16_t> as Temperature;
	uses interface Read<uint16_t> as Luminosity;
}

implementation {

	bool busy = FALSE;
	message_t pkt;
	uint16_t versionID = 0;
	am_addr_t parentNode;
	uint16_t temperatureVal;
	uint16_t lumVal;
	
	
	event void Boot.booted(){
		AMControl.start();  //initializing radios
	}

	event void AMControl.startDone(error_t err) {
		if(err != SUCCESS) {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) { } // do nothing

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		am_id_t type = call AMPacket.type(msg);

		if (type == AM_TOPO_REQ) {
			if (len == sizeof(WirelessNetworkPayloadMsg1)) {
				WirelessNetworkPayloadMsg1* req = (WirelessNetworkPayloadMsg1*) payload;

				if (req->pl_idMsg > versionID) {
					parentNode = call AMPacket.source(msg);
					versionID = req->pl_idMsg;
					post	respondTopoReq();
					
				}
			}
		} else if (type == AM_SENSOR_REQ) {
			if (len == sizeof(WirelessNetworkPayloadMsg3)) {
				WirelessNetworkPayloadMsg3* req	= (WirelessNetworkPayloadMsg3*) payload;

				if (req->pl_idMsg > versionID) {
					versionID = req->pl_idMsg;
					post respondSensorReq();
				}
			}
		} else if(type == AM_SENSOR_RESPONSE || type == AM_TOPO_RESPONSE){
			if (len == sizeof(WirelessNetworkPayloadMsg4) ) {
				if (req->pl_idMsg > versionID) {
					versionID = req->pl_idMsg;
					forwardSensorReq(payload);
				}
			} else if(len == sizeof(WirelessNetworkPayloadMsg2)){
				if (req->pl_idMsg > versionID) {
					versionID = req->pl_idMsg;
					forwardTopoReq(payload);
				}
			}
			
		}

		return msg;
	}
	

	event void AMSend.sendDone(message_t* msg, error_t err)	{
		if(err != SUCCESS){
			am_id_t type = call AMPacket.type(msg);
			if (type == AM_TOPO_REQ) post	respondTopoReq();
			else if (type == AM_SENSOR_RESPONSE) post respondSensorReq();
		}
	}

	task void respondTopoReq()	{
		WirelessNetworkPayloadMsg2 output;
		WirelessNetworkPayloadMsg2* topoReq = (WirelessNetworkPayloadMsg2*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg2));
		topoReq->pl_idMsg = versionID;
		topoReq->pl_parentNode = parentNode;
		topoReq->pl_originNode = TOS_NODE_ID;

		if(call	AMSend.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg2)) != SUCCESS)
			post respondTopoReq();
	}

	task void respondSensorReq()	{
		WirelessNetworkPayloadMsg4 output;
		WirelessNetworkPayloadMsg4* sensorReq = (WirelessNetworkPayloadMsg4*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg4));
		
		//Tenta pegar os dados dos sensores
		call Luminosity.read();
		call Temperature.read();

		sensorReq->pl_idMsg = versionID;
		sensorReq->pl_LumData = lumVal
		sensorReq->pl_TempData = tempVal;
		sensorReq->pl_Origin  = TOS_NODE_ID;
		sensorReq-> extra_data[0] =  time(NULL); //timestamp
		
		if(call	AMSend.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg4)) != SUCCESS)
			post respondSensorReq();
		
	}

	
	void forwardTopoReq(void* payload){
				
		if(call	AMSend.send(AM_BROADCAST_ADDR,	payload, sizeof(WirelessNetworkPayloadMsg2)) != SUCCESS)
			post forwardTopoReq();
		
		// se der errado, trocar a msg output por sendTopoReq
		
	}

	void forwardSensorReq(void* payload){
		
		if(call	AMSend.send(parentNode,	payload, sizeof(WirelessNetworkPayloadMsg4)) != SUCCESS)
			forwardTopoReq();		
		
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

