/*
	Configuration File 
*/

configuration WirelessNetworkBaseAppC{
}
implementation{
	components WirelessNetworkBaseC as App,
	components Mainc;
	components new TimerMilliC() as Timer0;
	components Packet;
	components AMPacket;
	components new AMSenderC(); // nao sei se precisa de algum parametro p instanciar
	components AMSend;
	components Receive;
	components SplitControl;
	// serial components - forwards the sensor readings to the PC
	components SerialActiveMessageC;
	components new SerialAMSenderC(AM_BLINKTORADIOMSG);

	App.Boot -> MainC;
	App.Timer0 -> Timer0;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.Receive -> AMReceiverC;
	App.AMControl -> ActiveMessageC;


	BlinkToRadioC.AMSend -> SerialAMSenderC;
	BlinkToRadioC.AMControl -> SerialActiveMessageC;
}
