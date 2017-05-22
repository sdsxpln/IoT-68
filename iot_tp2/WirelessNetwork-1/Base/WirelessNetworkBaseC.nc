/*
	Component File - definition (implementation) of the component
*/

#include <Timer.h>
#include "WirelessNetworkMessages.h"

module WirelessNetworkBaseC{

	uses interface Boot;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
	uses interface Timer<TMilli> as Timer0;

}

implementation {

	bool busy = FALSE;
	message_t pkt;
	uint16_t versionID = 1 ;
	uint16_t temperatureVal;
	uint16_t lumVal;
	

	event void Boot.booted(){
		AMControl.start();  //initializing radios
	}

	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			//call Timer0.startPeriodic(TIMER_PERIOD_MILLI); //start the Timer 
		}
		else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) { } // do nothing


	void autonomousMode(int time){

	}

	void activeMode(){

	}

	task void sendTopoReq(){

		versionID++;
	}

	task void sendSensorReq(){
		WirelessNetworkPayloadMsg3 output;
		WirelessNetworkPayloadMsg3* topoReq = (WirelessNetworkPayloadMsg3*) call Packet.getPayload(&output,sizeof(WirelessNetworkPayloadMsg3));
		topoReq->pl_idMsg = versionID;

		if(call	AMSend.send(parentNode,	&output, sizeof(WirelessNetworkPayloadMsg3)) != SUCCESS)
			post respondTopoReq();

		versionID++;
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		am_id_t type = call AMPacket.type(msg);

		if(type == AM_SENSOR_RESPONSE){
			if (len == sizeof(WirelessNetworkPayloadMsg4) ) {
				if (req->pl_idMsg > versionID) {
					versionID = req->pl_idMsg;
					forwardSensorReq(payload);
				}
			}
		}
		else if(type == AM_TOPO_RESPONSE){
			if(len == sizeof(WirelessNetworkPayloadMsg2)){
				if (req->pl_idMsg > versionID) {
					versionID = req->pl_idMsg;
					forwardTopoReq(payload);
				}
			}			
		}
		
	}	


}