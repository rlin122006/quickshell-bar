import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Rectangle {
    implicitHeight: 26
    implicitWidth: soundText.implicitWidth + 16
    color: hover.hovered ? Theme.highlightModuleBackgroundColor : Theme.moduleBackgroundColor
    radius: 16

    Text {
        id: soundText
        anchors.centerIn: parent
        color: hover.hovered ? Theme.highlightTextColor : Theme.textColor
        font.family: Theme.mapleMono
        text: (micInUse ? "󰍬" : "󰍭") + 
        " " +
        ((Pipewire.defaultAudioSink?.audio?.muted ?? false) ? "󰖁" : "󰕾")
    }

    TapHandler {
        onTapped: pavcontrol.running = true
    }

    // opens pavucontrol
    Process {
        id: pavcontrol
        command: ["sh", "-c", "pkill pavucontrol || (pavucontrol &)"]
    }

    // tracks pipewire audio sinks
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    // check whether mic is being listened on by anything
    property bool micInUse: {
        const source = Pipewire.defaultAudioSource

        if (!source) {
            return false
        }

        const links = Pipewire.links.values
        return links.some(link => link.source === source)
    }

    HoverHandler {
        id: hover
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }
}
