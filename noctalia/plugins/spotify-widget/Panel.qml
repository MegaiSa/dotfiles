import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.Commons
import qs.Widgets

Item {
    id: root

    property var pluginApi: null

    readonly property var geometryPlaceholder: panelContainer
    readonly property bool allowAttach: true

    property real contentPreferredWidth: 320 * Style.uiScaleRatio
    property real contentPreferredHeight: 90 * Style.uiScaleRatio

    anchors.fill: parent

    readonly property var player: Mpris.players.values.find(p => p.identity && p.identity.toLowerCase().indexOf("spotify") !== -1) ?? (Mpris.players.values[0] ?? null)
    readonly property bool hasPlayer: player !== null

    Rectangle {
        id: panelContainer
        anchors.fill: parent
        radius: Style.radiusL
        clip: true
        color: "transparent"

        Image {
            anchors.fill: parent
            source: root.player?.trackArtUrl ?? ""
            fillMode: Image.PreserveAspectCrop
            opacity: 0.35
            visible: root.hasPlayer
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.5)
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 12

            Image {
                source: root.player?.trackArtUrl ?? ""
                Layout.preferredWidth: 60
                Layout.preferredHeight: 60
                fillMode: Image.PreserveAspectCrop
                visible: root.hasPlayer
            }

            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true

                NText {
                    text: root.hasPlayer ? (root.player.trackTitle || "Titre inconnu") : "Aucune musique en cours"
                    color: "white"
                    font.weight: Font.Medium
                    pointSize: Style.fontSizeM
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                NText {
                    text: root.hasPlayer ? (root.player.trackArtist || "") : ""
                    color: Qt.rgba(1, 1, 1, 0.65)
                    pointSize: Style.fontSizeS
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                RowLayout {
                    spacing: 14
                    visible: root.hasPlayer

                    NIcon {
                        icon: "player-skip-back"
                        color: "white"
                        pointSize: Style.fontSizeM
                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.player?.previous()
                        }
                    }

                    NIcon {
                        icon: root.hasPlayer && root.player.playbackState === MprisPlaybackState.Playing ? "player-pause" : "player-play"
                        color: "white"
                        pointSize: Style.fontSizeL
                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.player?.togglePlaying()
                        }
                    }

                    NIcon {
                        icon: "player-skip-forward"
                        color: "white"
                        pointSize: Style.fontSizeM
                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.player?.next()
                        }
                    }
                }
            }
        }
    }
}
