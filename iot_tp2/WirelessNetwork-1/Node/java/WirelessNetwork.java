import java.io.IOException;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

public class WirelessNetwork implements MessageListener {
	// nao sei se esse MoteIF é "padrao" (se tem que deixar assim ou se tem que mudar)
	private MoteIF BaseStation;
	private int idMsg = 0;

	public WirelessNetwork() {
		this.BaseStation = new MoteIF(PrintStreamMessenger.err);
		this.BaseStation.registerListener(new WirelessNetworkMsg2(), this); 
		this.BaseStation.registerListener(new WirelessNetworkMsg4(), this); 
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
				payload.set_pl_idMsg(idMsg);
				incrIdMsg();
				System.out.println(payload.toString());
				BaseStation.send(MoteIF.TOS_BCAST_ADDR, payload);
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
				payload.set_pl_idMsg(idMsg);
				incrIdMsg();
				BaseStation.send(MoteIF.TOS_BCAST_ADDR, payload);
		}
		catch (IOException exception) {
			System.err.println("Exception thrown when sending packets. Exiting.");
			System.err.println(exception);
		}
	}

	public synchronized void messageReceived(int to, Message message) {
		int amType = message.amType();

		System.out.println("Tipo: " + amType);

		switch (amType) {
			case WirelessNetworkMsg2.AM_TYPE:
				WirelessNetworkMsg2 msg = (WirelessNetworkMsg2)message;
				System.out.println("Tipo: " + amType);
				System.out.println("ID: " + msg.get_pl_idMsg());
				System.out.println("Origem: " + msg.get_pl_originNode());
				System.out.println("Pai: " + msg.get_pl_parentNode());
				System.out.println("-------------------------------------");
				break;
			case WirelessNetworkMsg4.AM_TYPE:
				WirelessNetworkMsg4 msg4 = (WirelessNetworkMsg4)message;
				System.out.println("Tipo: " + amType);
				System.out.println("ID: " + msg4.get_pl_idMsg());
				System.out.println("Origem: " + msg4.get_pl_Origin());
				System.out.println("Luminosidade: " + msg4.get_pl_LumData());
				System.out.println("Temperatura: " + msg4.get_pl_TempData());
				System.out.println("-------------------------------------");
				break;
			default:
				System.err.println("Erro ao ler tipo do pacote AM_TYPE = " + amType);
				break;
		}
	}

	public void setIdMsg(int x){
		this.idMsg = x;	
	}
	
	public int getIdMsg(){
		return this.idMsg;	
	}

	public void incrIdMsg(){
		this.idMsg++;
	}


	public static void main(String[] args) throws Exception {
		WirelessNetwork serial = new WirelessNetwork();
		serial.sendType1Packets();

		while (true) {
   		try {
			 	System.out.println("Aguardando dados...");
				serial.sendType1Packets();
			 	Thread.sleep(2000);
      } catch (InterruptedException exception) {}
		}
	}
}


