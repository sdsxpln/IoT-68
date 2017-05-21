
#ifndef WIRELESSNETWORKMESSAGES_H__
#define WIRELESSNETWORKMESSAGES_H__

enum {
	AM_TOPO_REQ = 1;
	AM_TOPO_RESPONSE = 2;
	AM_SENSOR_REQ = 3;
	AM_SENSOR_RESPONSE = 4;
};

typedef struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
} WirelessNetworkPayloadMsg1;

typedef struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
  uint16_t pl_parentNode;
  uint16_t pl_originNode;
} WirelessNetworkPayloadMsg2;

typedef struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
} WirelessNetworkPayloadMsg3;

typedef struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
  uint16_t pl_LumData;
  uint16_t pl_TempData;
  uint16_t pl_Origin;
  /* dados extra - 20 bytes - mas n sei se e assim 
  uint64_t pl_extraData1; 
  uint64_t pl_extraData2; 
  uint32_t pl_extraData3; 
  */
} WirelessNetworkPayloadMsg4;





#endif //WIRELESSNETWORKMESSAGE_H__
