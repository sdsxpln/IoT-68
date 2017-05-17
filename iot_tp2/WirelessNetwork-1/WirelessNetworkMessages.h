
#ifndef WIRELESSNETWORKMESSAGES_H__
#define WIRELESSNETWORKMESSAGES_H__

enum {
	AM_TOPO_REQ = 1;
	AM_TOPO_RESPONSE = 2;
	AM_SENSOR_REQ = 3;
	AM_SENSOR_RESPONSE = 4;
};

// requisicao da topologia
typedef nx_struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg; //payload id message
} WirelessNetworkPayloadMsg1;

// resposta de topologia
typedef nx_struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
  uint16_t pl_parentNode;
  uint16_t pl_originNode;
} WirelessNetworkPayloadMsg2;

// requisicao de leitura
typedef nx_struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
} WirelessNetworkPayloadMsg3;

// resposta de leitura
typedef nx_struct WirelessNetworkPayloadMsg{
  uint16_t pl_idMsg;
  uint16_t pl_LumData;
  uint16_t pl_TempData;
  uint16_t pl_Origin;
  uint16_t extra_data[10];
} WirelessNetworkPayloadMsg4;


#endif //WIRELESSNETWORKMESSAGE_H__
