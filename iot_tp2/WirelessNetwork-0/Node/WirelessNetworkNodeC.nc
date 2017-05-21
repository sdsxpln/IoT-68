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
}

implementation {

	bool busy = FALSE;
	message_t pkt;

	event void Boot.booted(){
		AMControl.start();  //initializing radios
	}

	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			// espera receber msgs
		}
		else {
			call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) { } // do nothing

	/* precisa mudar 
	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(BlinkToRadioMsg)) {
			BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg*)payload;
			call Leds.set(btrpkt->counter);
		}
		return msg;
	}
	*/

}

