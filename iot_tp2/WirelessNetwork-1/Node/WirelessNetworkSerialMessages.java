import java.io.IOException;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class WirelessNetworkSerialMessages implements MessageListener {
	// nao sei se esse MoteIF é "padrao" (se tem que deixar assim ou se tem que mudar)
	private MoteIF BaseStation;
	private int idMsg = 0;

	public WirelessNetworkSerialMessages(MoteIF BaseStation) {
		this.BaseStation = BaseStation;
		this.BaseStation.registerListener(new WirelessNetworkMsg1(), this); 
		//ver na doc desse registerListener se pode ter diferentes tipos de mensagens 
		// associadas a um nó ou se é só uma msg para cada nó
		// Se é só as mensagens que ele envia ou se conta as msgs que ele recebe tb
		// se puder ter mais mensagens, isso talvez de certo:
		//this.BaseStation.registerListenet(new WirelessNetworkMsg3(), this);

	}

	public void sendType1Packets() {
		//int counter = 0;
		WirelessNetworkMsg1 payload = new WirelessNetworkMsg1();

		try {
			while (true) {
				//System.out.println("Sending packet " + counter);
				//payload.set_counter(counter);
				payload.set_pl_idMsg(idMsg);
				incrIdMsg();
				moteIF.send(0, payload);
				//counter++;
				try {Thread.sleep(1000);}
				catch (InterruptedException exception) {}
			}
		}
		catch (IOException exception) {
			System.err.println("Exception thrown when sending packets. Exiting.");
			System.err.println(exception);
		}
	}

	public void sendType3Packets() {
		//int counter = 0;
		WirelessNetworkMsg3 payload = new WirelessNetworkMsg3();

		try {
			while (true) {
				//System.out.println("Sending packet " + counter);
				//payload.set_counter(counter);
				payload.set_pl_idMsg(idMsg);
				incrIdMsg();
				moteIF.send(0, payload);
				//counter++;
				try {Thread.sleep(1000);}
				catch (InterruptedException exception) {}
			}
		}
		catch (IOException exception) {
			System.err.println("Exception thrown when sending packets. Exiting.");
			System.err.println(exception);
		}
	}

	public void messageReceived(int to, Message message) {

		/*	Recebida de outros nós ou recebida da USB? ou dos dois?
			aqui que temos que verificar pelo tipo
		*/
		if( /*type(message) == AM_WIRELESSNETWORKPAYLOAD2*/){
			WirelessNetworkMsg2 msg = (WirelessNetworkMsg1)message;
			System.out.println("Received packet sequence number " + msg.get_counter());	
		}else if () {
		
		}else{
					
		}
	}

	public void setIdMsg(int x){
		this.idMsg = x;	
	}
	
	public int getIdMsg(){
		return this.idMgs;	
	}

	public void incrIdMsg(){
		this.idMsg++;
	}


	 public static void main(String[] args) throws Exception {
		String source = null;
		if (args.length == 2) {
		if (!args[0].equals("-comm")) {
			usage();
			System.exit(1);
		}
			source = args[1];
		}
		else if (args.length != 0) {
			usage();
			System.exit(1);
		}

		// nao entendi pra que isso serve
		PhoenixSource phoenix;

		if (source == null) {
			phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
		}
		else {
			phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
		}
		
		// nao sei se esse MoteIF é "padrao" (se tem que deixar assim ou se tem que mudar)
		MoteIF BaseStation = new MoteIF(phoenix); // ?? 
		WirelessNetworkSerialMessages serial = new WirelessNetworkSerialMessages(mif); //??
		serial.sendType1Packets();
	}
}


