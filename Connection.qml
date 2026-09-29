import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    property string mainInterfaceStatus: "unknown"

    implicitHeight: 26
    implicitWidth: 26 //connectionRow.implicitWidth + 16
    color: Theme.moduleBackgroundColor
    radius: 16

    Row {
        id: connectionRow
        anchors.centerIn: parent
        spacing: 2
        
        // battery icon
        Text { 
            font.family: Theme.mapleMono
            color: Theme.textColor
            text: connectionIcon(mainInterfaceStatus)
        }
    }

    // check interfaces every 5 seconds
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            mainInterfaceCheck.running = true
        }
    }

    // check main wifi interace connection
    Process {
        id: mainInterfaceCheck
        command: ["cat", "/sys/class/net/wlp99s0/operstate"]

        stdout: SplitParser {
            onRead: data => {mainInterfaceStatus = data.trim()}
        }
    }

    // return the wifi icon
    function connectionIcon(mainInterfaceStatus) {
        if (mainInterfaceStatus === "up") return ""
        if (mainInterfaceStatus === "down") return ""
        return "?"
    }
}
