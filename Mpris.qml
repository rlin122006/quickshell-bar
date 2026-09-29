import Quickshell.Services.Mpris
import Quickshell.Io
import QtQuick

Rectangle {
    property bool rmpcRunning: false
    property bool spotifyRunning: false

    implicitHeight: 26
    implicitWidth: mprisText.implicitWidth > 0 ? mprisText.implicitWidth + 16 : 0
    color: hover.hovered ? Theme.highlightModuleBackgroundColor : Theme.moduleBackgroundColor 
    radius: 16

    Text {
        id: mprisText
        anchors.centerIn: parent
        color: hover.hovered ? Theme.highlightTextColor : Theme.textColor
        font.family: Theme.mapleMono
        text: {
            if (!player) return ""
            if (!rmpcRunning && !spotifyRunning) return ""
            const icon = player.playbackState === MprisPlaybackState.Playing ? "⏸" : "▶"
            return `${icon} ${player.trackTitle || "Unknown"} ~ ${player.trackArtist || "Unknown"} (${formatSecs(player.position)}/${formatSecs(player.length)})`
        }
    }

    // toggles playing
    TapHandler {
        onTapped: if (player?.canTogglePlaying) player.togglePlaying()
    }

    // checks for playback time
    Timer {
        interval: 1000
        running: player?.playbackState === MprisPlaybackState.Playing
        repeat: true
        onTriggered: {if (player) player.positionChanged()}
    }

    // checks for music players
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            rmpcCheck.running = true
            spotifyCheck.running = true
        }
    }

    // checks if rmpc is running
    Process {
        id: rmpcCheck
        command: ["pgrep", "-x", "rmpc"]
        onExited: (exitCode) => { rmpcRunning = exitCode === 0 }
    }

    // check if spotify is running
    Process {
        id: spotifyCheck
        command: ["pgrep", "-x", ".spotify-wrappe"]
        onExited: (exitCode) => { spotifyRunning = exitCode === 0 }
    }

    // formats the time of the song
    function formatSecs(s) {
        if (s === undefined || s === null || s < 0) {
            return "0:00"
        }
        const total = Math.floor(s)
        return `${Math.floor(total / 60)}:${String(total % 60).padStart(2, '0')}`
    }

    // blocked sources
    property var player: {
        const blocked = ["firefox"]
        const active = Mpris.players.values.filter(p => {
            if (blocked.includes(p.desktopEntry)) return false
            if (p.desktopEntry === "mpd-mpris" && !rmpcRunning) return false
            if (p.desktopEntry === "spotify" && !spotifyRunning) return false
            const title = p.trackTitle?.trim()
            const artist = p.trackArtist?.join("").trim()
            if (!title && !artist) return false
            return true
        })
        const playing = active.find(p => p.playbackState === MprisPlaybackState.Playing)
        return playing ?? active[0] ?? null
    }

    HoverHandler {
        id: hover
    }

    Behavior on color {
        ColorAnimation { duration: 150 }
    }
    
    Behavior on implicitWidth {
        NumberAnimation { duration : 75; easing.type: Easing.InOutQuad }
    }
}
