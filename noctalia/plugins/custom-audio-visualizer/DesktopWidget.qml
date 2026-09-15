import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets
import qs.Services.Media
import qs.Modules.DesktopWidgets

DraggableDesktopWidget {
    id: root

    property var pluginApi: null

    showBackground: false

    // ---- Independent width / height ----
    property real boxWidth: Screen.width * 0.95
    property real boxHeight: 150

    implicitWidth: boxWidth
    implicitHeight: boxHeight

    // ---- Appearance ----
    property int barCount: 96
    property real barSpacing: 1
    property bool mirrored: true
    property bool fadeWhenIdle: false

    // ---- SpectrumService registration ----
    readonly property string spectrumInstanceId: "plugin:custom-audio-visualizer:" + Date.now() + Math.random()

    onPluginApiChanged: {
        if (pluginApi) {
            SpectrumService.registerComponent(spectrumInstanceId)
        }
    }

    Component.onDestruction: {
        SpectrumService.unregisterComponent(spectrumInstanceId)
    }

    opacity: (fadeWhenIdle && SpectrumService.isIdle) ? 0.0 : 1.0
    Behavior on opacity { NumberAnimation { duration: 400 } }

    Row {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        spacing: root.barSpacing

        Repeater {
            model: root.barCount

            Item {
                width: (root.width - (root.barCount - 1) * root.barSpacing) / root.barCount
                height: root.height
                anchors.verticalCenter: parent.verticalCenter

                property real level: {
                    var vals = SpectrumService.values || []
                    if (vals.length === 0) return 0
                    var i = root.mirrored
                        ? Math.abs(index - (root.barCount - 1) / 2) / (root.barCount / 2)
                        : index / root.barCount
                    var srcIndex = Math.min(vals.length - 1,
                        Math.floor((root.mirrored ? (1 - i) : (index / root.barCount)) * vals.length))
                    return vals[srcIndex] || 0
                }

                Behavior on level { NumberAnimation { duration: 60 } }

                // Symmetric bar: grows both up and down from the vertical center
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width
                    height: Math.max(2, parent.height * parent.level)
                    radius: width / 2
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.0; color: Qt.rgba(Color.mPrimary.r, Color.mPrimary.g, Color.mPrimary.b, 0.3) }
                        GradientStop { position: 0.5; color: Color.mPrimary }
                        GradientStop { position: 1.0; color: Qt.rgba(Color.mPrimary.r, Color.mPrimary.g, Color.mPrimary.b, 0.3) }
                    }
                }
            }
        }
    }
}
