#ifndef WIRELESSNETWORKMSG2_H__
#define WIRELESSNETWORKMSG2_H__

enum {
	AM_WIRELESSNETWORKPAYLOADMSG2 = 2
};

// resposta de topologia
typedef nx_struct WirelessNetworkPayloadMsg{
  nx_uint16_t pl_idMsg;
  nx_uint16_t pl_parentNode;
  nx_uint16_t pl_originNode;
} WirelessNetworkPayloadMsg2;


#endif //WIRELESSNETWORKMSG2_H__
