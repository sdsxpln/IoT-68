GEN=WirelessNetworkMsg1.java WirelessNetworkMsg2.java WirelessNetworkMsg3.java WirelessNetworkMsg4.java

all: wirelessNetwork.jar

wirelessNetwork.jar: WirelessNetwork.class
	jar cf $@ *.class

WirelessNetwork.class: $(wildcard *.java) $(GEN)
	javac *.java

WirelessNetworkMsg1.java: ../WirelessNetworkMsg1.h
	mig java -target=null -java-classname=WirelessNetworkMsg1 ../WirelessNetworkMsg1.h WirelessNetworkPayloadMsg1 -o $@

WirelessNetworkMsg2.java: ../WirelessNetworkMsg2.h
	mig java -target=null -java-classname=WirelessNetworkMsg2 ../WirelessNetworkMsg2.h WirelessNetworkPayloadMsg2 -o $@

WirelessNetworkMsg3.java: ../WirelessNetworkMsg3.h
	mig java -target=null -java-classname=WirelessNetworkMsg3 ../WirelessNetworkMsg3.h WirelessNetworkPayloadMsg3 -o $@

WirelessNetworkMsg4.java: ../WirelessNetworkMsg4.h
	mig java -target=null -java-classname=WirelessNetworkMsg4 ../WirelessNetworkMsg4.h WirelessNetworkPayloadMsg4 -o $@

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm wirelessNetwork.jar
