/*
	Configuration File 


	If you want to assign a different identifier for each node you have to enter:
	make mica2 reinstall.ID mib510,serialport
	Where ID is the identifier you want to give to your mote, for example 0,1,32,...
*/
#include "WirelessNetworkMessages.h"
configuration WirelessNetworkNodeAppC{
}
implementation{
	components WirelessNetworkNodeC as App;
	components MainC;
	components LedsC;
	components ActiveMessageC;
	components new AMSenderC(AM_WIRELESSNETWORKPAYLOADMSG1) as AMS1;
	components new AMSenderC(AM_WIRELESSNETWORKPAYLOADMSG2) as AMS2;
	components new AMSenderC(AM_WIRELESSNETWORKPAYLOADMSG3) as AMS3;
	components new AMSenderC(AM_WIRELESSNETWORKPAYLOADMSG4) as AMS4;
	components new AMReceiverC(AM_WIRELESSNETWORKPAYLOADMSG1) as AMR1;
	components new AMReceiverC(AM_WIRELESSNETWORKPAYLOADMSG2) as AMR2;
	components new AMReceiverC(AM_WIRELESSNETWORKPAYLOADMSG3) as AMR3;
	components new AMReceiverC(AM_WIRELESSNETWORKPAYLOADMSG4) as AMR4;
	components new TempC() as TempC;
	components new PhotoC() as PhotoC ;
	

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Packet -> ActiveMessageC;
	App.AMPacket -> ActiveMessageC;
	App.AMS1 -> AMS1;
	App.AMS2 -> AMS2;
	App.AMS3 -> AMS3;
	App.AMS4 -> AMS4;
	App.AMR1 -> AMR1;
	App.AMR2 -> AMR2;
	App.AMR3 -> AMR3;
	App.AMR4 -> AMR4;
	App.RadioControl -> ActiveMessageC;
	
	App.Temperature -> TempC;
	App.Luminosity -> PhotoC;
}
