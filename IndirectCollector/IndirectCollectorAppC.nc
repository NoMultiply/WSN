#include <Timer.h>
#include "IndirectCollector.h"

configuration IndirectCollectorAppC {
}
implementation {
  components MainC;
  components LedsC;
  components IndirectCollectorC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIO);
  components new SensirionSht11C() as Sensor;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Read -> Sensor.Temperature;
}
