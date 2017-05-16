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
}

