import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    implicitHeight: 26
    implicitWidth: rowLayout.implicitWidth + 16
    color: Theme.moduleBackgroundColor
    radius: 16
    
    RowLayout {
        id: rowLayout
        anchors.centerIn: parent

        Repeater {
            property int workspaceCount: 8
            model: workspaceCount
            delegate: Rectangle {
                id: wsRectangle
                implicitWidth: isActiveHere ? 24 : 16
                implicitHeight: 18
                color: isActiveHere ? Theme.highlightModuleBackgroundColor : "transparent"
                radius : 16

                readonly property int wsId: index + 1
                readonly property string wsName: wsId.toString()

                // workspace lookup
                readonly property HyprlandWorkspace workspace: {
                    for (let i = 0; i < Hyprland.workspaces.values.length; i++) {
                        const ws = Hyprland.workspaces.values[i];
                        if (ws.id === wsId) return ws;
                    }
                    return null;
                }

                // checks for active workspace
                readonly property bool isActiveHere: {
                    if (!workspace) return false;
                    if (!workspace.monitor) return false;
                    return workspace.active
                        && !!workspace.monitor 
                }

                Text {
                    id: label
                    anchors.centerIn: parent
                    font.family: Theme.mapleMono
                    color: wsRectangle.isActiveHere ? Theme.highlightTextColor : Theme.textColor
                    text: wsRectangle.wsName
                }

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Behavior on implicitWidth {
                    NumberAnimation { duration: 75; easing.type: Easing.InOutQuad }
                }
            }
        }
    }
}
