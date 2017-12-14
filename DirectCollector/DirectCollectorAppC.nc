#include <Timer.h>
#include "DirectCollector.h"

configuration DirectCollectorAppC {
}
implementation {
  components MainC;
  components LedsC;
  components DirectCollectorC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIO);
  components new SensirionSht11C() as Sensor;
  components new HamamatsuS1087ParC() as IlluminationSensor;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.ReadTemperature -> Sensor.Temperature;
  App.ReadHumidity -> Sensor.Humidity;
  App.ReadIllumination -> IlluminationSensor;
}
