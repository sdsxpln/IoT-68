package iot_tp1;

import com.alien.enterpriseRFID.reader.*;
import com.alien.enterpriseRFID.tags.*;
import java.util.*;

public class ActiveReader {

	 private static Map<String, Integer> dictTags;
	 
	 //Constructor	 
	 public ActiveReader(String ip, int port, int numReads){
		 dictTags = new HashMap<>();
		 try{
			 AlienClass1Reader reader = setActiveReader1(ip, port);
			 openConn(reader);
			 testIfOpen(reader);
			 //printDict();
			 readNTimes(numReads, reader);
			 //printDict();
			 getAllSuccessRate(numReads);
			 closeConn(reader);
			 testIfOpen(reader);
		 }
		 catch(AlienReaderException e){
			System.out.println("Error:" + e.toString());
		 }		 				
	 }	 
	 
	 public static AlienClass1Reader setActiveReader1(String ip, int port) throws AlienReaderException {
		 AlienClass1Reader reader = new AlienClass1Reader();
		 reader.setConnection(ip, port);
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
	 
	 public static void readNTimes(int ntimes, AlienClass1Reader reader){
		 try{
			 for(int i = 0; i < ntimes; i++){
				 System.out.println("\nTentativa "+ i);
				 Tag tagList[] = reader.getTagList();
				 if (tagList == null) {
					    System.out.println("No Tags Found");
				 }
				 else {
				    System.out.println("Tag(s) found:");
				    for (int j=0; j<tagList.length; j++) {
				      Tag tag = tagList[j];
				      System.out.println("ID:" + tag.getTagID() +
				                         //", Discovered:" + tag.getDiscoverTime() +
				                         //", Last Seen:" + tag.getRenewTime() +
				                         //", Antenna:" + tag.getAntenna() +
				                         ", Reads:" + tag.getRenewCount()  //conta qtas vezes a tag foi lida
				                         );				    
				      
				      
					  if( dictTags.get(tag.getTagID()) == null ){
						  System.out.println("Adicionando ao dicionario");
						  dictTags.put(tag.getTagID(), 1 );						
					  }else{
						  //se ja existir, incrementa
						  System.out.println("Incrementando leitura");
						  dictTags.put(tag.getTagID(),  dictTags.get(tag.getTagID()) + 1 ) ; 
					  }				    
				    }
				}
			 }
		 }
		 catch(AlienReaderException e){
			  System.out.println(e);
		 }
	}
	
	public static void printDict(){
		for(String tag : dictTags.keySet() ){
			System.out.println("A Tag " + tag + " foi lida " + dictTags.get(tag) + "vezes");
		}
	} 
	 
	// se for pra pegar de uma especifica
	public static double getSuccessRate( int reads, int ntimes ){
		return (float) reads / (float) ntimes * 100.0; 
	}
	
		
	//se for pra pegar de muitas  
	public void getAllSuccessRate(int ntimes){
		for( String tag : dictTags.keySet() ){
			double successRate = (float) dictTags.get(tag) / (float) ntimes * 100.0;
			System.out.println("A Tag " + tag + " obteve uma taxa de sucesso de " + successRate+ "%");
		}
	}
        
        public Map<String, Integer> getDic(){
            return this.dictTags; 
        };
} 