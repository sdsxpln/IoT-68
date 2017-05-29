GEN=WirelessNetworkMsg1.java WirelessNetworkMsg2.java WirelessNetworkMsg3.java WirelessNetworkMsg4.java

all: wirelessNetwork.jar

wirelessNetwork.jar: WirelessNetwork.class
	jar cf $@ *.class

WirelessNetwork.class: $(wildcard *.java) $(GEN)
	javac *.java

WirelessNetworkMsg1.java: ../WirelessNetworkMessages.h
	mig java -target=null -java-classname=WirelessNetworkMsg1 ../WirelessNetworkMessages.h WirelessNetworkPayloadMsg1 -o $@

WirelessNetworkMsg2.java: ../WirelessNetworkMessages.h
	mig java -target=null -java-classname=WirelessNetworkMsg2 ../WirelessNetworkMessages.h WirelessNetworkPayloadMsg2 -o $@

WirelessNetworkMsg3.java: ../WirelessNetworkMessages.h
	mig java -target=null -java-classname=WirelessNetworkMsg3 ../WirelessNetworkMessages.h WirelessNetworkPayloadMsg3 -o $@

WirelessNetworkMsg4.java: ../WirelessNetworkMessages.h
	mig java -target=null -java-classname=WirelessNetworkMsg4 ../WirelessNetworkMessages.h WirelessNetworkPayloadMsg4 -o $@

clean:
	rm -f *.class $(GEN)

veryclean: clean
	rm wirelessNetwork.jar
