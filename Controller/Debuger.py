# encoding= utf-8
from ControllerUi.Debuger_ui import Ui_DebugerGUI
from PyQt4.QtGui import QMainWindow, QIntValidator, QApplication
from SerialInterface import SerialInterface

CONTROL_START = 2
CONTROL_STOP = 1


class DebugerGui(Ui_DebugerGUI, QMainWindow):

    def __init__(self):
        super(DebugerGui, self).__init__()
        self.setupUi(self)
        self.m_clear1.clicked.connect(self.m_result1.clear)
        self.m_clear2.clicked.connect(self.m_result2.clear)
        self.m_send.clicked.connect(self.send_start)
        self.m_stop.clicked.connect(self.send_stop)
        self.interface = SerialInterface()
        self.interface.received.connect(self.show_received)
        self.m_interval.setValidator(QIntValidator(0, 10000))
        self.m_interval.returnPressed.connect(self.send_start)
        self.count1 = -1
        self.count2 = -1

    def closeEvent(self, event):
        self.interface.mif.finishAll()

    def show_received(self, node_id, sequence_num, timestamp, temperature, humidity, illumination):
        string = "node_id: %d, sequence_num: %d, timestamp: %d, temperature: %d, humidity: %d, illumination: %d" %\
                 (node_id, sequence_num, timestamp, temperature, humidity, illumination)
        if node_id == 1:
            self.m_result1.append(string)
            if self.count1 >= 0 and (sequence_num - self.count1) > 1:
                self.m_result1.append(u"\n丢包！！！\n")
            self.count1 = sequence_num
        elif node_id == 2:
            self.m_result2.append(string)
            if self.count2 >= 0 and (sequence_num - self.count2) > 1:
                self.m_result2.append(u"\n丢包！！！\n")
            self.count2 = sequence_num

    def send_start(self):
        self.interface.send(CONTROL_START, int(self.m_interval.text()))

    def send_stop(self):
        self.interface.send(CONTROL_STOP)


if __name__ == '__main__':
    import sys
    app = QApplication(sys.argv)
    controller = DebugerGui()
    controller.show()
    sys.exit(app.exec_())
