/*
	Configuration File 
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

	App.Boot -> MainC.Boot;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.Receive -> AMReceiverC;
	App.AMControl -> ActiveMessageC;

}
