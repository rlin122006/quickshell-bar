import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

Rectangle {
    id: root

    readonly property int workspaceCount: 8
    readonly property int baseWidth: 16
    readonly property int extraWidth: 8
    readonly property int gap: 5
    readonly property int sidePadding: 8
    readonly property int animMs: 150

    readonly property var screen: QsWindow.window ? QsWindow.window.screen : null
    readonly property var monitor: Hyprland.monitorFor(screen)
    readonly property int activeId:
        monitor && monitor.activeWorkspace ? monitor.activeWorkspace.id : -1
    readonly property bool hasActive: activeId >= 1 && activeId <= workspaceCount

    property real pos: Math.max(0, Math.min(activeId - 1, workspaceCount - 1))
    property real presence: hasActive ? 1 : 0
    Behavior on pos { NumberAnimation { duration: root.animMs; easing.type: Easing.InOutQuad } }
    Behavior on presence { NumberAnimation { duration: root.animMs } }

    implicitHeight: 26
    implicitWidth: sidePadding * 2 + workspaceCount * baseWidth
                   + (workspaceCount - 1) * gap + extraWidth
    color: Theme.moduleBackgroundColor
    radius: 16

    Item {
        id: track
        x: root.sidePadding
        height: 18
        y: (root.height - height) / 2

        Repeater {
            model: root.workspaceCount
            delegate: Rectangle {
                id: slot
                required property int index

                readonly property real weight:
                    root.presence * Math.max(0, 1 - Math.abs(index - root.pos))
                readonly property real before:
                    root.presence * Math.max(0, Math.min(1, index - root.pos))

                x: index * (root.baseWidth + root.gap) + root.extraWidth * before
                width: root.baseWidth + root.extraWidth * weight
                height: track.height
                radius: 16

                readonly property color hl: Theme.highlightModuleBackgroundColor
                color: Qt.rgba(hl.r, hl.g, hl.b, hl.a * weight)

                Text {
                    x: (parent.width - width) / 2
                    y: (parent.height - height) / 2
                    font.family: Theme.mapleMono
                    text: slot.index + 1
                    color: Qt.tint(Theme.textColor,
                                   Qt.alpha(Theme.highlightTextColor, slot.weight))
                }
            }
        }
    }
}
