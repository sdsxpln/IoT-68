/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package iot_tp1;

/**
 *
 * @author gabrielvcbessa
 */
public class IoT_TP1 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        
        String ip = "150.164.10.42";
        Integer port = 23;
        Integer ntimes = 5;
        String ipRecv = "150.160.10.148";
	Integer recPort = 4000;
	Integer notifyTime = 1; // s
	Integer stopTime = 2000; // ms
        
        ActiveReader activeReader = new ActiveReader(ip, port, ntimes);
        //activeReader.getAllSuccessRate(100);
       
        try {
            AutReader authReader = new AutReader(ip, port, ipRecv, recPort, notifyTime, stopTime);
        } catch (Exception e){
            System.out.println("Error:" + e.toString());
        }
    }
}