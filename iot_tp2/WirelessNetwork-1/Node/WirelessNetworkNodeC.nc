/*
	Component File - definition (implementation) of the component
*/

#include "WirelessNetworkMessages.h"

module WirelessNetworkC{

	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface Receive;
	uses interface SplitControl as AMControl;
	uses interface Read<uint16_t>;
}

implementation {

	bool busy = FALSE;
	message_t pkt;
	uint16_t versionID;
	am_addr_t parentNode;

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
		} else if (type == AM_SENSOR_RESPONSE) {
			if (len == sizeof(WirelessNetworkPayloadMsg3)) {
				WirelessNetworkPayloadMsg3* req	= (WirelessNetworkPayloadMsg3*) payload;

				if (req->pl_idMsg > versionID) {
					versionID = req->pl_idMsg;
					post respondSensorReq();
				}
			}
		}

		return msg;
	}
	

	event void AMSend.sendDone(message_t* msg, error_t err)	{
		/*if (err == SUCCESS)	{
				// Prepare next packet if needed
		}
		else {
			//TRATAR QUAL REQUISAO FOI FEITA
			post respondTopoReq();
			post respondSensorReq();

		}*/

		if(err != SUCCESS){
			am_id_t type = call AMPacket.type(msg);
			if (type == AM_TOPO_REQ) post	respondTopoReq();
			else if (type == AM_SENSOR_RESPONSE) post respondSensorReq();
		}
	}

	task void respondTopoReq()	{
		WirelessNetworkPayloadMsg2* topoReq = (WirelessNetworkPayloadMsg2*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg2));
		topoReq->pl_idMsg = versionID;
		topoReq->pl_parentNode = parentNode;
		topoReq->pl_originNode = TOS_NODE_ID;

		if(call	AMSend.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg2)) != SUCCESS)
			post respondTopoReq();
	}

	task void respondSensorReq()	{
		WirelessNetworkPayloadMsg4* sensorReq = (WirelessNetworkPayloadMsg4*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg4));
		topoReq->pl_idMsg = versionID;
		topoReq->pl_parentNode = parentNode;
		topoReq->pl_originNode = TOS_NODE_ID;

		//Tenta PEGA OS DADOS DOS SENSORES - ?
		int i = 0;		
		while(i < 10 && call Read.read() != SUCCESS ){
			i++;
		}
		


		if(call	AMSend.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg4)) != SUCCESS)
			post respondSensorReq();
	}

	// msg ja vem com payload?
	task void forwardBroadcastMessage(message_t* msg){
	
	}

	//The Read interface (in tinyos-2.x/tos/interfaces) can be used to read a *single* piece of sensor data,
	command error_t read();
	event void readDone( error_t result, val_t val );
}

