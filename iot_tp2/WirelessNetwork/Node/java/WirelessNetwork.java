import java.io.IOException;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import java.io.*;

public class WirelessNetwork implements MessageListener {

        private MoteIF BaseStation;
        private int idMsg = 1;
        private String topoString = "";
        private String dataQueue = "";

        public WirelessNetwork() {
                this.BaseStation = new MoteIF(PrintStreamMessenger.err);
                this.BaseStation.registerListener(new WirelessNetworkMsg2(), this);
                this.BaseStation.registerListener(new WirelessNetworkMsg4(), this);

        }

        public void sendType1Packets() {

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

                WirelessNetworkMsg3 payload = new WirelessNetworkMsg3();

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
                                this.topoString += this.createTopoObject(msg.get_pl_idMsg(), msg.get_pl_originNode(), msg.get_pl_parentNode());
                                break;

                        case WirelessNetworkMsg4.AM_TYPE:
                                WirelessNetworkMsg4 msg4 = (WirelessNetworkMsg4)message;
                                System.out.println("Tipo: " + amType);
                                System.out.println("ID: " + msg4.get_pl_idMsg());
                                System.out.println("Origem: " + msg4.get_pl_Origin());
                                System.out.println("Luminosidade: " + msg4.get_pl_LumData());
                                System.out.println("Temperatura: " + msg4.get_pl_TempData());
                                System.out.println("-------------------------------------");
                                this.dataQueue += this.createDataObject(msg4.get_pl_idMsg(), msg4.get_pl_Origin(), msg4.get_pl_TempData(), msg4.get_pl_LumData());
                                break;

                        default:
                                System.err.println("Couldn't read pkg type " + amType);
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

 		public String createTopoObject(int id, int origin, int parent){
                String returnedString = "";
                returnedString += "{\"versionID\":";
                returnedString += String.valueOf(id) + ",\"origin\":";
                returnedString += String.valueOf(origin) + ",\"parent\":";
                returnedString += String.valueOf(parent);
                returnedString += "},";
                return returnedString;
        }

        public String createDataObject(int id, int origin, int temp, int photo){
                String returnedString = "";
                returnedString += "{\"versionID\":";
                returnedString += String.valueOf(id) + ",\"origin\":";
                returnedString += String.valueOf(origin) + ",\"temp\":";
                returnedString += String.valueOf(temp) + ",\"photo\":";
                returnedString += String.valueOf(photo);
                returnedString += "},";
                return returnedString;
        }


        public void writeResults() {
                try{
                        PrintWriter topoWriter = new PrintWriter("topo.txt", "UTF-8");
                        topoWriter.println("[" + this.topoString + "]");
                        topoWriter.close();

                        PrintWriter dataWriter = new PrintWriter("data.txt", "UTF-8");
                        dataWriter.println("[" + this.dataQueue + "]");
                        dataWriter.close();

                } catch (IOException e) {
                        // do something
                }
        }

             public static void main(String[] args) throws Exception {

                if (args.length < 2) {
                        System.out.println("Sorry bro, I need to args to run");
                        System.out.println("./run <pkgType> <sleepTime>");
                        return;
                }

                int pkgType = Integer.parseInt(args[0]);
                int sleepTime = Integer.parseInt(args[1]);
                WirelessNetwork serial = new WirelessNetwork();

                System.out.println( "pkgType: " + pkgType + " sleepTime: " + sleepTime);

                if (pkgType == 1) serial.sendType1Packets();
                else serial.sendType3Packets();

                Thread.sleep(sleepTime);
                serial.writeResults();
                System.out.println("Hey Capitan, I am done! See u later");
                System.exit(0);
        }
}

