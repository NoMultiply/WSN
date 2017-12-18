#include <Timer.h>
#include "../WSN.h"

module IndirectCollectorC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend as DataSend;
  uses interface Receive as ControlReceive;
  uses interface SplitControl as AMControl;
  uses interface Read<uint16_t> as ReadTemperature;
  uses interface Read<uint16_t> as ReadHumidity;
  uses interface Read<uint16_t> as ReadIllumination;
  uses interface Counter<T32khz,uint16_t> as Msp430Counter32khz;
}

implementation {
  message_t pkt;
  nxSYS_Time_t SysClock = { 0, 0 };
  DataMsg msgPkt;
  bool temperatureBusy = FALSE;
  bool humidityBusy = FALSE;
  bool illuminationBusy = FALSE;
  uint16_t count = 0;
  void SendPacket() {
    if (temperatureBusy && humidityBusy && illuminationBusy) {
      DataMsg* collectPacket = (DataMsg*)(call Packet.getPayload(&pkt, sizeof(DataMsg)));
      if (collectPacket == NULL) {
        return;
      }
      call Leds.led2Toggle();
      collectPacket->nodeid = TOS_NODE_ID;
      collectPacket->temperature = msgPkt.temperature;
      collectPacket->humidity = msgPkt.humidity;
      collectPacket->illumination = msgPkt.illumination;
      collectPacket->sequence_num = count;
      collectPacket->timestamp = SysClock.timestamp;
      if (!(call DataSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(DataMsg)) == SUCCESS)) {
        temperatureBusy = FALSE;
        humidityBusy = FALSE;
        illuminationBusy = FALSE;
      }
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  void GetTime() {
    uint16_t temp;
    temp = call Msp430Counter32khz.get();
    atomic {
      SysClock.ticks = temp;
      SysClock.timestamp = SysClock.ticks_round * 2048 + SysClock.ticks / 32;
    }
  }

  async event void Msp430Counter32khz.overflow()
  {
    call Msp430Counter32khz.clearOverflow();
    atomic {
      SysClock.ticks_round += 1;
    }
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
    GetTime();
  }

  event void DataSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      temperatureBusy = FALSE;
      humidityBusy = FALSE;
      illuminationBusy = FALSE;
      count++;
    }
  }

  event message_t* ControlReceive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(ControlMsg)) {
      ControlMsg* controlPkt = (ControlMsg*)payload;
      call Leds.led0Toggle();
      if (controlPkt->control_type == CONTROL_STOP) {
        call Timer0.stop();
      }
      else {
        call Timer0.startPeriodic(controlPkt->interval);
      }
    }
    return msg;
  }
}
