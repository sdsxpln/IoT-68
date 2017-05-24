#ifndef WIRELESSNETWORKMSG1_H__
#define WIRELESSNETWORKMSG1_H__

enum {
	AM_WIRELESSNETWORKPAYLOADMSG1 = 1
};

// requisicao da topologia
typedef nx_struct WirelessNetworkPayloadMsg{
  nx_uint16_t pl_idMsg; //payload id message
} WirelessNetworkPayloadMsg1;



#endif //WIRELESSNETWORKMSG1_H__
