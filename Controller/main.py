from PyQt4.QtGui import QApplication
from Controller import ControllerGui

if __name__ == '__main__':
    import sys
    app = QApplication(sys.argv)
    controller = ControllerGui()
    controller.show()
    sys.exit(app.exec_())