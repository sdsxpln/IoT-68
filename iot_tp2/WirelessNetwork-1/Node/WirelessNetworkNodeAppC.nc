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
	components new AMSenderC(0x01) as AMS1;
	components new AMSenderC(0x02) as ASM2;
	components new AMSenderC(0x03) as ASM3;
	components new AMSenderC(0x04) as ASM4;
	components new AMReceiverC(0x01) as AMR1;
	components new AMReceiverC(0x02) as AMR2;
	components new AMReceiverC(0x03) as AMR3;
	components new AMReceiverC(0x04) as AMR4;
	components new DemoSensorC() as TempC;
	components new DemoSensorC() as PhotoC;


	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Packet -> AMS1;
	App.AMPacket -> AMS1;
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
