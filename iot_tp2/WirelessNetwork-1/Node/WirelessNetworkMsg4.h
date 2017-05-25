#ifndef WIRELESSNETWORKMSG4_H__
#define WIRELESSNETWORKMSG4_H__

enum {
	AM_WIRELESSNETWORKPAYLOADMSG4 = 4
};

// resposta de leitura
typedef nx_struct WirelessNetworkPayloadMsg4{
  nx_uint16_t pl_idMsg;
  nx_uint16_t pl_LumData;
  nx_uint16_t pl_TempData;
  nx_uint16_t pl_Origin;
  nx_uint16_t extra_data[10];
} WirelessNetworkPayloadMsg4;

#endif //WIRELESSNETWORKMSG4_H__
