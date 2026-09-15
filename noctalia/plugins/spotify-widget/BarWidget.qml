import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.Commons
import qs.Widgets

Rectangle {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    readonly property var player: MprisController.players.find(p => p.identity?.toLowerCase().includes("spotify")) ?? null

    implicitWidth: Style.barHeight
    implicitHeight: Style.barHeight

    color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
    radius: Style.radiusM
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    NIcon {
        anchors.centerIn: parent
        icon: "brand-spotify"
        color: Color.mPrimary
    }

    MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: pluginApi?.openPanel(root.screen, root)
    }
}
