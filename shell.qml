//@ pragma UseQApplication
import Quickshell
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData

            screen: modelData
            implicitHeight: 46
            implicitWidth: Screen.width
            color: "transparent"
            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                color: Theme.backgroundColor
                radius: 23
                anchors {
                    fill: parent
                    leftMargin: 8
                    rightMargin: 8
                    topMargin: 8
                }

                // left area
                Row {
                    spacing: 8
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 8
                    }

                    Workspaces {}
                }

                // mid area
                Row {
                    spacing: 8
                    anchors {
                        centerIn: parent
                    }

                    Mpris{}
                }

                // right area
                Row {
                    spacing: 8
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 8
                    }

                    SystemTray {}
                    Sound {}
                    Connection {}
                    Battery {}
                    Clock {}
                }
            }
        }
    }
}
