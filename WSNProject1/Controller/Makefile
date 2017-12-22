#COMPONENT=TestSerialAppC
#BUILD_EXTRA_DEPS += DataMsg.py
#CLEAN_EXTRA = DataMsg.py

all: DataMsg.py ControlMsg.py

DataMsg.py:
	mig python -target=null $(CFLAGS) -python-classname=DataMsg ../WSN.h DataMsg -o $@

ControlMsg.py:
	mig python -target=null $(CFLAGS) -python-classname=ControlMsg ../WSN.h ControlMsg -o $@

clean:
	rm -f DataMsg.py
	rm -f ControlMsg.py
#include $(MAKERULES)
