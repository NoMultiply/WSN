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
  enum {
    DATA_QUEUE_LEN = 12,
  };
  message_t dataQueueBufs[DATA_QUEUE_LEN];
  message_t * ONE_NOK dataQueue[DATA_QUEUE_LEN];
  uint8_t dataIn, dataOut;
  bool dataBusy, dataFull;

  message_t pkt;
  nxSYS_Time_t SysClock = { 0, 0, 0 };
  DataMsg dataPkt;
  uint16_t count = 0;

  task void sendData();

  void SendPacket() {
    DataMsg* collectPacket = (DataMsg*)(call Packet.getPayload(&pkt, sizeof(DataMsg)));
    if (collectPacket == NULL) {
      return;
    }
    call Leds.led2Toggle();
    collectPacket->nodeid = TOS_NODE_ID;
    collectPacket->temperature = dataPkt.temperature;
    collectPacket->humidity = dataPkt.humidity;
    collectPacket->illumination = dataPkt.illumination;
    collectPacket->sequence_num = count;
    atomic collectPacket->timestamp = SysClock.timestamp;
    atomic {
      if (!dataFull) {
        dataQueue[dataIn] = &pkt;

        dataIn = (dataIn + 1) % DATA_QUEUE_LEN;

        if (dataIn == dataOut) {
          dataFull = TRUE;
        }

        if (!dataFull) {
          post sendData();
          dataBusy = TRUE;
        }
      }
    }
  }

  event void Boot.booted() {
    uint8_t i;
    for (i = 0; i < DATA_QUEUE_LEN; ++i) {
      dataQueue[i] = &dataQueueBufs[i];
    }
    dataIn = dataOut = 0;
    dataBusy = FALSE;
    dataFull = TRUE;

    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      dataFull = FALSE;
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
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

  event void ReadTemperature.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      dataPkt.temperature = (nx_uint16_t)(-40.1+ 0.01 * data);
    }
  }

  event void ReadHumidity.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
      dataPkt.humidity = (nx_uint16_t)(-4.0 + 4.0 * data / 100.0 + (-28.0 / 1000.0 / 10000.0) * (data * data));
      dataPkt.humidity = (nx_uint16_t)((dataPkt.temperature - 25.0) * (1.0 / 100.0 + 8.0 * data / 100.0 / 1000.0) + dataPkt.humidity);
    }
  }

  event void ReadIllumination.readDone(error_t result, uint16_t data)
  {
    if (result == SUCCESS){
        dataPkt.illumination = data;
    }
  }

  event void Timer0.fired() {
    call ReadTemperature.read();
    call ReadHumidity.read();
    call ReadIllumination.read();
    ++count;
    GetTime();
    SendPacket();
  }

  task void sendData() {
    message_t * msg;
    atomic if (dataIn == dataOut && !dataFull) {
      dataBusy = FALSE;
      return;
    }

    msg = dataQueue[dataOut];
    if (!(call DataSend.send(AM_BROADCAST_ADDR, msg, sizeof(DataMsg)) == SUCCESS)) {
      call Leds.led1Toggle();
    }
    else {
      //TODO
    }
  }

  event void DataSend.sendDone(message_t* msg, error_t err) {
    if (err != SUCCESS) {
      //TODO
    }
    else {
      atomic if (msg == dataQueue[dataOut]) {
        if (++dataOut >= DATA_QUEUE_LEN) {
          dataOut = 0;
        }
        if (dataFull) {
          dataFull = FALSE;
        }
      }
    }
    post sendData();
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
