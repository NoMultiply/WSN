#include <Timer.h>
#include "DirectCollector.h"

module DirectCollectorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as ReadTemperature;
  uses interface Read<uint16_t> as ReadHumidity;
  uses interface Read<uint16_t> as ReadIllumination;
}
implementation {

  message_t pkt;
  message_t rpkt;
  DirectCollectorMsg * msgrPkt;
  DirectCollectorMsg msgPkt;
  bool temperatureBusy = FALSE;
  bool humidityBusy = FALSE;
  bool illuminationBusy = FALSE;
  uint16_t count = 0;
  uint16_t timestamp = 0;
  void SendPacket() {
    if (temperatureBusy && humidityBusy && illuminationBusy) {
      DirectCollectorMsg* collectPacket = (DirectCollectorMsg*)(call Packet.getPayload(&pkt, sizeof(DirectCollectorMsg)));
      if (collectPacket == NULL) {
        return;
      }
      call Leds.led2Toggle();
      collectPacket->nodeid = TOS_NODE_ID;
      collectPacket->temperature = msgPkt.temperature;
      collectPacket->humidity = msgPkt.humidity;
      collectPacket->illumination = msgPkt.illumination;
      collectPacket->sequence_num = count;
      collectPacket->timestamp = timestamp * TIMER_PERIOD_MILLI;
      if (!(call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(DirectCollectorMsg)) == SUCCESS)) {
        temperatureBusy = FALSE;
        humidityBusy = FALSE;
        illuminationBusy = FALSE;
      }
    }
  }

  task void SendReceive() {
    DirectCollectorMsg* collectPacket = (DirectCollectorMsg*)(call Packet.getPayload(&rpkt, sizeof(DirectCollectorMsg)));
    if (collectPacket == NULL) {
      return;
    }
    call Leds.led2Toggle();
    collectPacket->nodeid = msgrPkt->nodeid;
    collectPacket->temperature = msgrPkt->temperature;
    collectPacket->humidity = msgrPkt->humidity;
    collectPacket->illumination = msgrPkt->illumination;
    collectPacket->sequence_num = msgrPkt->sequence_num;
    collectPacket->timestamp = msgrPkt->timestamp;
    if (!(call AMSend.send(AM_BROADCAST_ADDR, &rpkt, sizeof(DirectCollectorMsg)) == SUCCESS)) {
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void ReadTemperature.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      if (!temperatureBusy) {
        msgPkt.temperature = (nx_uint16_t)(-40.1+ 0.01 * data);
        temperatureBusy = TRUE;
        SendPacket();
      }
    }
  }

  event void ReadHumidity.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      if (!humidityBusy && temperatureBusy) {
        msgPkt.humidity = (nx_uint16_t)(-4.0 + 4.0 * data / 100.0 + (-28.0 / 1000.0 / 10000.0) * (data * data));
        msgPkt.humidity = (nx_uint16_t)((msgPkt.temperature - 25.0) * (1.0 / 100.0 + 8.0 * data / 100.0 / 1000.0) + msgPkt.humidity);
        humidityBusy = TRUE;
        SendPacket();
      }
    }
  }

  event void ReadIllumination.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      if (!illuminationBusy) {
        msgPkt.illumination = data;
        illuminationBusy = TRUE;
        SendPacket();
      }
    }
  }

  event void Timer0.fired() {
    call ReadTemperature.read();
    call ReadHumidity.read();
    call ReadIllumination.read();
    timestamp++;
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      temperatureBusy = FALSE;
      humidityBusy = FALSE;
      illuminationBusy = FALSE;
      count++;
    }
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(DirectCollectorMsg)) {
      msgrPkt = (DirectCollectorMsg*)payload;
      call Leds.led1Toggle();
      post SendReceive();
    }
    return msg;
  }
}
