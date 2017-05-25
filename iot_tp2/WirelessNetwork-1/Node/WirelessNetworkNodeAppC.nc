/*
	Configuration File 


	If you want to assign a different identifier for each node you have to enter:
	make mica2 reinstall.ID mib510,serialport
	Where ID is the identifier you want to give to your mote, for example 0,1,32,...
*/
#include "WirelessNetworkMsg1.h"
#include "WirelessNetworkMsg2.h"
#include "WirelessNetworkMsg3.h"
#include "WirelessNetworkMsg4.h"
configuration WirelessNetworkNodeAppC{
}
implementation{
	components WirelessNetworkNodeC as App;
	components MainC;
	components LedsC;
	components ActiveMessageC;
	components new AMSenderC(0x02);
	components new AMReceiverC(AM_WIRELESSNETWORKNODE);
	components new DemoSensorC() as TempC;
	components new DemoSensorC() as PhotoC;


	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.Receive -> AMReceiverC;
	App.RadioControl -> ActiveMessageC;
	App.Temperature -> TempC;
	App.Luminosity -> PhotoC;
}
