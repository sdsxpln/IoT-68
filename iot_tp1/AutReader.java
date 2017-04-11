
package iot_tp1;

import com.alien.enterpriseRFID.reader.*;
import com.alien.enterpriseRFID.tags.*;
import com.alien.enterpriseRFID.notify.*;

import java.util.HashMap;
import java.util.Map;

public class AutReader implements MessageListener  {

    private static Map<String, Integer> dictTags;


    //Constructor.
    public AutReader(String ip, int port, String ipRecv, int servicePort, int notifyTime, int stopTime) throws Exception{
            dictTags = new HashMap<>();

            AlienClass1Reader reader = this.setActiveReader(ip, port);
            MessageListenerService service = this.setupMessListenerService(servicePort);
            openConn(reader);
            testIfOpen(reader);	
            setNotifications(reader,ipRecv, servicePort, notifyTime);
            turnOnAutoMode(stopTime, reader);
            getReads(reader);
            closeConn(reader);
            waitMessages(service, stopTime);
            System.out.println("\nResetting Reader");
            openConn(reader);
            turnOffAutoMode(reader);
            closeConn(reader);
            getAllReadRate();		
    }

    public MessageListenerService setupMessListenerService(int port){
              MessageListenerService service = null;
              try{
                      service = new MessageListenerService(port);
                      service.setMessageListener(this);
                      service.startService();
                      System.out.println("Message Listener has Started");			  
              }
              catch (Exception e) {
                    System.out.println(e);
              }		

              return service;	
    }

    public static AlienClass1Reader setActiveReader(String ipAlien, int port) throws AlienReaderException {
             AlienClass1Reader reader = new AlienClass1Reader();
             reader.setConnection(ipAlien, port);
             reader.setUsername("alien");
             reader.setPassword("password");

             return reader;
     }

    public static void openConn(AlienClass1Reader reader){
             try{
                     reader.open();
                     System.out.println("Conexao aberta");
             }
             catch(AlienReaderException e){
                     System.out.println(e);
             }
     }

    public static void closeConn(AlienClass1Reader reader){
             reader.close();		 
             System.out.println("Conexao encerrada");
     }	 

    public static void testIfOpen(AlienClass1Reader reader){
              if(reader.isOpen()){
                      System.out.println("Leitor aberto!");
                      try{ 
                              System.out.println(reader.getReaderName());
                      }catch(AlienReaderException e){
                              System.out.println(e);
                      }
              }else{
                      System.out.println("Fechado!");
              }		 
     }

    public static void setNotifications(AlienClass1Reader reader, String ipRecv, int portRecv, int notifyTime){
             try{
                     reader.setNotifyAddress(ipRecv, portRecv); //quando estiver na VPN
                     reader.setNotifyTime(notifyTime);
                     reader.setNotifyFormat(AlienClass1Reader.XML_FORMAT); // Make sure service can decode it.
                     reader.setNotifyTrigger("TrueFalse"); // Notify whether there's a tag or not
                     //reader.setNotifyTrigger("OFF"); //descomentar para o leitor que termina em  .41
                     reader.setNotifyMode(AlienClass1Reader.ON); 
             }
             catch(Exception e){
                     System.out.println(e);
             }
     }

    public static void turnOnAutoMode(int stopTime, AlienClass1Reader reader){
      // Set up AutoMode
      try{
              reader.autoModeReset();
              reader.setAutoStopTimer(stopTime); // parametro em milisegundos
              reader.setAutoMode(AlienClass1Reader.ON);
      }
      catch (Exception e) {
            System.out.println(e);
      }
    }

    public static void getReads(AlienClass1Reader reader){
            try{
                    Tag tagList[] = reader.getTagList();
                     if (tagList == null) {
                                System.out.println("No Tags Found");
                     }
                     else {
                        System.out.println("Tag(s) found:");
                        for (int j=0; j<tagList.length; j++) {
                          Tag tag = tagList[j];
                          System.out.println("ID:" + tag.getTagID() +
                                             ", Reads:" + tag.getRenewCount()  //conta qtas vezes a tag foi lida
                                             );

                                if( dictTags.get(tag.getTagID()) == null ){
                                            System.out.println("Adicionando ao dicionario");
                                            dictTags.put(tag.getTagID(), tag.getRenewCount() );						
                                    }else{
                                            //se ja existir, incrementa
                                            System.out.println("Incrementando leitura");
                                            dictTags.put(tag.getTagID(),  dictTags.get(tag.getTagID()) + tag.getRenewCount() ) ; 
                                    }
                        }
                    }
            }
            catch (Exception e) {
                    System.out.println(e);
            }
    }

    public static void waitMessages(MessageListenerService service, int runTime){
            //spin while messages arrive
            try{
                    long startTime = System.currentTimeMillis();

                    do {
                        Thread.sleep(1000);
                    } while(service.isRunning() && (System.currentTimeMillis()-startTime) < runTime);

            }catch(Exception e) {
                    System.out.println(e);
            }
    } 

    public static void turnOffAutoMode(AlienClass1Reader reader){
              try{
                      reader.autoModeReset();
                      reader.setNotifyMode(AlienClass1Reader.OFF);			  
              }
              catch (Exception e) {
                      System.out.println(e);
              }
    }

    public static void printDict(){
            for(String tag : dictTags.keySet() ){
                    System.out.println("A Tag " + tag + " foi lida " + dictTags.get(tag) + "vezes");
            }
    }

    public static void getAllReadRate() {
            for(String tag : dictTags.keySet() ){
                    int rr = dictTags.get(tag);
                    System.out.println("A Tag " + tag + " foi lida " + rr + " vezes no ultimo segundo");

            }		
    }

    /**
     * A single Message has been received from a Reader.
     *
     * @param message the notification message received from the reader
     */
    @Override
    public void messageReceived(Message message){
      System.out.println("\nMessage Received:");
      if (message.getTagCount() == 0) {
        System.out.println("(No Tags)");
      } else {
        for (int i = 0; i < message.getTagCount(); i++) {
          Tag tag = message.getTag(i);
          System.out.println(tag.toLongString());
        }
      }
    }
    
    public Map<String, Integer> getDic(){
        return this.dictTags;
    };
}