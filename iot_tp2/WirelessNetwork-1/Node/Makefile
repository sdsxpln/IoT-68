COMPONENT=WirelessNetworkNodeAppC
sensorboard=mda100
include $(MAKERULES)

WirelessNetworkNodeAppC.class: $(wildcard *.java) WirelessNetworkMessages.java
	javac *.java

WirelessNetworkMsg1.java:
	mig java -target=iris -java-classname=WirelessNetworkMsg1 WirelessNetworkMsg1.h WirelessNetworkPayloadMsg1 -o $@

WirelessNetworkMsg2.java:
	mig java -target=iris -java-classname=WirelessNetworkMsg2 WirelessNetworkMsg2.h WirelessNetworkPayloadMsg2 -o $@

WirelessNetworkMsg3.java:
	mig java -target=iris -java-classname=WirelessNetworkMsg3 WirelessNetworkMsg3.h WirelessNetworkPayloadMsg3 -o $@

WirelessNetworkMsg4.java:
	mig java -target=iris -java-classname=WirelessNetworkMsg4 WirelessNetworkMsg4.h WirelessNetworkPayloadMsg4 -o $@


