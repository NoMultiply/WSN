#include <Timer.h>

configuration CalculatorAppC {
}

implementation {
  components MainC;
  components LedsC;
  components CalculatorC as App;
  components ActiveMessageC;
  components new AMReceiverC(AM_SENDER) as RandomDataReceiver;
  components new AMReceiverC(AM_CO) as CoReceiver;
  components new AMReceiverC(AM_CO) as CoReceiver2;
  components new AMSenderC(AM_CO) as ReqSender;
  components new AMSenderC(AM_MSG) as ResSender;
  components new AMReceiverC(AM_MSG) as AckReceicer;
  components new TimerMilliC() as Timer0;

  components PrintfC;
  components SerialStartC;

  App.Boot -> MainC;
  App.AMControl -> ActiveMessageC;
  App.RandomDataReceive -> RandomDataReceiver;
  App.CoReceive -> CoReceiver;
  App.CoReceive2 -> CoReceiver2;
  App.AckReceice -> AckReceicer;
  App.Packet -> ReqSender;
  App.AMPacket -> ReqSender;
  App.Leds -> LedsC;
  App.ReqSend -> ReqSender;
  App.ResSend -> ResSender;
  App.ReqAck -> ReqSender;
  App.Timer0 -> Timer0;
}
