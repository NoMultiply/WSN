from ControllerUi.Controller_ui import Ui_ControllerGUI
from PyQt4.QtGui import QMainWindow, QIntValidator, QBrush, QColor, QVBoxLayout, QSpacerItem
from PyQt4.Qt import QSizePolicy
from SerialInterface import SerialInterface
from pyqtgraph import PlotWidget
from DeviceItem import DeviceItem

CONTROL_START = 2
CONTROL_STOP = 1


class ControllerGui(Ui_ControllerGUI, QMainWindow):

    def __init__(self):
        super(ControllerGui, self).__init__()
        self.setupUi(self)
        self.m_clear.clicked.connect(self.clear_plot)
        self.m_send.clicked.connect(self.send_start)
        self.m_stop.clicked.connect(self.send_stop)
        self.interface = SerialInterface()
        self.interface.received.connect(self.show_received)
        self.m_interval.setValidator(QIntValidator(0, 10000))
        self.m_interval.returnPressed.connect(self.send_start)

        brush = QBrush(QColor(255, 255, 255))

        box = QVBoxLayout(self.m_list)

        self.temperature_plot = PlotWidget(self)
        self.temperature_plot.setBackgroundBrush(brush)
        self.temperature_plot.setFixedHeight(300)
        box.addWidget(self.temperature_plot)
        self.temperature_curves = {}

        self.humidity_plot = PlotWidget(self)
        self.humidity_plot.setBackgroundBrush(brush)
        self.humidity_plot.setFixedHeight(300)
        box.addWidget(self.humidity_plot)
        self.humidity_curves = {}

        self.illumination_plot = PlotWidget(self)
        self.illumination_plot.setBackgroundBrush(brush)
        self.illumination_plot.setFixedHeight(300)
        box.addWidget(self.illumination_plot)
        self.illumination_curves = {}
        box.addItem(QSpacerItem(40, 20, QSizePolicy.Maximum, QSizePolicy.Expanding))
        self.m_list.setLayout(box)

        box = QVBoxLayout(self.m_devices)
        box.addItem(QSpacerItem(40, 20, QSizePolicy.Maximum, QSizePolicy.Expanding))
        self.m_devices.setLayout(box)

    def closeEvent(self, event):
        self.interface.mif.finishAll()

    def show_received(self, node_id, sequence_num, timestamp, temperature, humidity, illumination):
        try:
            temperature_curve = self.temperature_curves[str(node_id)]
            humidity_curve = self.humidity_curves[str(node_id)]
            illumination_curve = self.illumination_curves[str(node_id)]
        except KeyError:
            temperature_curve = self.temperature_plot.plot([], [])
            humidity_curve = self.humidity_plot.plot([], [])
            illumination_curve = self.illumination_plot.plot([], [])
            self.temperature_curves[str(node_id)] = temperature_curve
            self.humidity_curves[str(node_id)] = humidity_curve
            self.illumination_curves[str(node_id)] = illumination_curve

            box = self.m_devices.layout()

            device_item = DeviceItem(self.m_devices, node_id)
            device_item.colorChanged.connect(self.set_device_color)
            self.set_device_color(node_id, device_item.color)
            device_item.showChanged.connect(self.change_device_show)
            device_item.temperatureChanged.connect(self.change_device_temperature)
            device_item.humidityChanged.connect(self.change_device_humidity)
            device_item.illuminationChanged.connect(self.change_device_illumination)

            box.insertWidget(box.count() - 1, device_item)
            self.m_aside.setFixedWidth(device_item.width())

        data = temperature_curve.getData()
        data_x, temperature_y = list(data[0]), list(data[1])
        data_x.append(timestamp / 1000.0)
        temperature_y.append(temperature)
        temperature_curve.setData(data_x, temperature_y)

        data = humidity_curve.getData()
        data_x, humidity_y = list(data[0]), list(data[1])
        data_x.append(timestamp / 1000.0)
        humidity_y.append(humidity)
        humidity_curve.setData(data_x, humidity_y)

        data = illumination_curve.getData()
        data_x, illumination_y = list(data[0]), list(data[1])
        data_x.append(timestamp / 1000.0)
        illumination_y.append(illumination)
        illumination_curve.setData(data_x, illumination_y)

    def send_start(self):
        self.interface.send(CONTROL_START, int(self.m_interval.text()))

    def send_stop(self):
        self.interface.send(CONTROL_STOP)

    def clear_plot(self):
        for key in self.temperature_curves:
            self.temperature_curves[key].setData([], [])
            self.humidity_curves[key].setData([], [])
            self.illumination_curves[key].setData([], [])

    def set_device_color(self, node_id, color):
        self.temperature_curves[str(node_id)].setPen(color)
        self.humidity_curves[str(node_id)].setPen(color)
        self.illumination_curves[str(node_id)].setPen(color)

    def change_device_show(self, node_id, check, t_check, h_check, i_check):
        if check:
            self.change_device_temperature(node_id, t_check)
            self.change_device_humidity(node_id, h_check)
            self.change_device_illumination(node_id, i_check)
        else:
            self.temperature_curves[str(node_id)].hide()
            self.humidity_curves[str(node_id)].hide()
            self.illumination_curves[str(node_id)].hide()

    def change_device_temperature(self, node_id, check):
        if check:
            self.temperature_curves[str(node_id)].show()
        else:
            self.temperature_curves[str(node_id)].hide()

    def change_device_humidity(self, node_id, check):
        if check:
            self.humidity_curves[str(node_id)].show()
        else:
            self.humidity_curves[str(node_id)].hide()

    def change_device_illumination(self, node_id, check):
        if check:
            self.illumination_curves[str(node_id)].show()
        else:
            self.illumination_curves[str(node_id)].hide()