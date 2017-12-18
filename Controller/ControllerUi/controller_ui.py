# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '/home/shatter/Desktop/WSN/Controller/ControllerUi/controller.ui'
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
        ControllerGUI.resize(800, 600)
        self.centralwidget = QtGui.QWidget(ControllerGUI)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.verticalLayout_2 = QtGui.QVBoxLayout(self.centralwidget)
        self.verticalLayout_2.setObjectName(_fromUtf8("verticalLayout_2"))
        self.verticalLayout = QtGui.QVBoxLayout()
        self.verticalLayout.setObjectName(_fromUtf8("verticalLayout"))
        self.horizontalLayout = QtGui.QHBoxLayout()
        self.horizontalLayout.setObjectName(_fromUtf8("horizontalLayout"))
        self.m_freq = QtGui.QLineEdit(self.centralwidget)
        self.m_freq.setObjectName(_fromUtf8("m_freq"))
        self.horizontalLayout.addWidget(self.m_freq)
        self.m_send = QtGui.QPushButton(self.centralwidget)
        self.m_send.setObjectName(_fromUtf8("m_send"))
        self.horizontalLayout.addWidget(self.m_send)
        self.m_clear = QtGui.QPushButton(self.centralwidget)
        self.m_clear.setObjectName(_fromUtf8("m_clear"))
        self.horizontalLayout.addWidget(self.m_clear)
        self.verticalLayout.addLayout(self.horizontalLayout)
        self.m_result = QtGui.QTextBrowser(self.centralwidget)
        self.m_result.setObjectName(_fromUtf8("m_result"))
        self.verticalLayout.addWidget(self.m_result)
        self.verticalLayout_2.addLayout(self.verticalLayout)
        ControllerGUI.setCentralWidget(self.centralwidget)
        self.menubar = QtGui.QMenuBar(ControllerGUI)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 31))
        self.menubar.setObjectName(_fromUtf8("menubar"))
        ControllerGUI.setMenuBar(self.menubar)

        self.retranslateUi(ControllerGUI)
        QtCore.QMetaObject.connectSlotsByName(ControllerGUI)

    def retranslateUi(self, ControllerGUI):
        ControllerGUI.setWindowTitle(_translate("ControllerGUI", "Controller", None))
        self.m_send.setText(_translate("ControllerGUI", "send", None))
        self.m_clear.setText(_translate("ControllerGUI", "clear", None))

