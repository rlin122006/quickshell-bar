import Quickshell
import QtQuick

Rectangle {
    implicitHeight: 26
    implicitWidth: clockText.implicitWidth + 16
    color: Theme.moduleBackgroundColor
    radius: 16

    Text {
        id: clockText
        anchors.centerIn: parent
        color: Theme.textColor
        font.family: Theme.mapleMono
        text: Qt.formatDateTime(clock.date, "ddd, MMM dd ~ hh:mm")
    }

    // integrated system clock
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
