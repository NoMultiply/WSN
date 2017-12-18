# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/shatter/Desktop/WSN/Controller/ControllerUi/Controller.ui'
#
# Created by: PyQt4 UI code generator 4.11.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_ControllerGUI(object):
    def setupUi(self, ControllerGUI):
        ControllerGUI.setObjectName(_fromUtf8("ControllerGUI"))
        ControllerGUI.setWindowModality(QtCore.Qt.WindowModal)
        ControllerGUI.resize(954, 587)
        self.centralwidget = QtGui.QWidget(ControllerGUI)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.verticalLayout_2 = QtGui.QVBoxLayout(self.centralwidget)
        self.verticalLayout_2.setObjectName(_fromUtf8("verticalLayout_2"))
        self.verticalLayout = QtGui.QVBoxLayout()
        self.verticalLayout.setObjectName(_fromUtf8("verticalLayout"))
        self.horizontalLayout_2 = QtGui.QHBoxLayout()
        self.horizontalLayout_2.setObjectName(_fromUtf8("horizontalLayout_2"))
        self.m_interval = QtGui.QLineEdit(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_interval.sizePolicy().hasHeightForWidth())
        self.m_interval.setSizePolicy(sizePolicy)
        self.m_interval.setObjectName(_fromUtf8("m_interval"))
        self.horizontalLayout_2.addWidget(self.m_interval)
        self.m_send = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_send.sizePolicy().hasHeightForWidth())
        self.m_send.setSizePolicy(sizePolicy)
        self.m_send.setObjectName(_fromUtf8("m_send"))
        self.horizontalLayout_2.addWidget(self.m_send)
        self.m_stop = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_stop.sizePolicy().hasHeightForWidth())
        self.m_stop.setSizePolicy(sizePolicy)
        self.m_stop.setObjectName(_fromUtf8("m_stop"))
        self.horizontalLayout_2.addWidget(self.m_stop)
        self.m_clear = QtGui.QPushButton(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Minimum, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_clear.sizePolicy().hasHeightForWidth())
        self.m_clear.setSizePolicy(sizePolicy)
        self.m_clear.setObjectName(_fromUtf8("m_clear"))
        self.horizontalLayout_2.addWidget(self.m_clear)
        self.verticalLayout.addLayout(self.horizontalLayout_2)
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.m_aside = QtGui.QScrollArea(self.centralwidget)
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Preferred, QtGui.QSizePolicy.Expanding)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.m_aside.sizePolicy().hasHeightForWidth())
        self.m_aside.setSizePolicy(sizePolicy)
        self.m_aside.setVerticalScrollBarPolicy(QtCore.Qt.ScrollBarAsNeeded)
        self.m_aside.setHorizontalScrollBarPolicy(QtCore.Qt.ScrollBarAlwaysOff)
        self.m_aside.setWidgetResizable(True)
        self.m_aside.setObjectName(_fromUtf8("m_aside"))
        self.m_devices = QtGui.QWidget()
        self.m_devices.setGeometry(QtCore.QRect(0, 0, 76, 497))
        self.m_devices.setObjectName(_fromUtf8("m_devices"))
        self.m_aside.setWidget(self.m_devices)
        self.horizontalLayout.addWidget(self.m_aside)
        self.m_body = QtGui.QScrollArea(self.centralwidget)
        self.m_body.setWidgetResizable(True)
        self.m_body.setObjectName(_fromUtf8("m_body"))
        self.m_list = QtGui.QWidget()
        self.m_list.setGeometry(QtCore.QRect(0, 0, 846, 497))
        self.m_list.setObjectName(_fromUtf8("m_list"))
        self.m_body.setWidget(self.m_list)
        self.horizontalLayout.addWidget(self.m_body)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.verticalLayout_2.addLayout(self.verticalLayout)
        ControllerGUI.setCentralWidget(self.centralwidget)
        self.menubar = QtGui.QMenuBar(ControllerGUI)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 954, 31))
        self.menubar.setObjectName(_fromUtf8("menubar"))
        ControllerGUI.setMenuBar(self.menubar)

        self.retranslateUi(ControllerGUI)
        QtCore.QMetaObject.connectSlotsByName(ControllerGUI)

    def retranslateUi(self, ControllerGUI):
        ControllerGUI.setWindowTitle(_translate("ControllerGUI", "Controller", None))
        self.m_interval.setText(_translate("ControllerGUI", "1000", None))
        self.m_send.setText(_translate("ControllerGUI", "send", None))
        self.m_stop.setText(_translate("ControllerGUI", "stop", None))
        self.m_clear.setText(_translate("ControllerGUI", "clear", None))

