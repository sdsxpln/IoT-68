#ifndef WIRELESSNETWORKMSG3_H__
#define WIRELESSNETWORKMSG3_H__

enum {
	AM_WIRELESSNETWORKPAYLOADMSG3 = 3

};

// requisicao de leitura
typedef nx_struct WirelessNetworkPayloadMsg3{
  nx_uint16_t pl_idMsg;
} WirelessNetworkPayloadMsg3;


#endif //WIRELESSNETWORKMSG3_H__
