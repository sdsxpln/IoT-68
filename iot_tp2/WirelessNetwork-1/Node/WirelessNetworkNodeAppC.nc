/*
	Configuration File 


	If you want to assign a different identifier for each node you have to enter:
	make mica2 reinstall.ID mib510,serialport
	Where ID is the identifier you want to give to your mote, for example 0,1,32,...
*/

configuration WirelessNetworkAppC{
}
implementation{
	components WirelessNetworkNodeC as App,
	components Mainc;
	components ActiveMessageC;
	components new AMSenderC(); // nao sei se precisa de algum parametro p instanciar
	components Packet;
	components AMPacket;
	components AMSend;
	components Receive;
	components SplitControl;
	components new DemoSensorC() as Sensor;


	App.Boot -> MainC.Boot;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.Receive -> AMReceiverC;
	App.AMControl -> ActiveMessageC;
	App.Temperature -> TempC;
	App.Luminosity -> PhotoC;
}
