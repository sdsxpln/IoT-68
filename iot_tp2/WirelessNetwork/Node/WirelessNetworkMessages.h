
#ifndef WIRELESSNETWORKMESSAGES_H__
#define WIRELESSNETWORKMESSAGES_H__

enum {
	AM_WIRELESSNETWORKPAYLOADMSG1 = 1,
	AM_WIRELESSNETWORKPAYLOADMSG2 = 2,
	AM_WIRELESSNETWORKPAYLOADMSG3 = 3,
	AM_WIRELESSNETWORKPAYLOADMSG4 = 4
};

// requisicao da topologia
typedef nx_struct WirelessNetworkPayloadMsg1{
  nx_uint16_t pl_idMsg; //payload id message
} WirelessNetworkPayloadMsg1;

// resposta de topologia
typedef nx_struct WirelessNetworkPayloadMsg2{
  nx_uint16_t pl_idMsg;
  nx_uint16_t pl_parentNode;
  nx_uint16_t pl_originNode;
} WirelessNetworkPayloadMsg2;

// requisicao de leitura
typedef nx_struct WirelessNetworkPayloadMsg3{
  nx_uint16_t pl_idMsg;
} WirelessNetworkPayloadMsg3;

// resposta de leitura
typedef nx_struct WirelessNetworkPayloadMsg4{
  nx_uint16_t pl_idMsg;
  nx_uint16_t pl_Origin;
  nx_uint16_t pl_LumData;
  nx_uint16_t pl_TempData;
  nx_uint16_t extra_data[10];
} WirelessNetworkPayloadMsg4;


#endif //WIRELESSNETWORKMESSAGE_H__
