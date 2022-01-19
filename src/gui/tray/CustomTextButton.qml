import QtQuick 2.15
import QtQuick.Controls 2.3
import Style 1.0

Item {
    id: root

    property string text: ""
    property string toolTipText: ""

    property color textColor: Style.unifiedSearchResulTitleColor
    property color textColorHovered: Style.unifiedSearchResulSublineColor

    property alias hovered: mouseArea.containsMouse

    signal clicked()

    Accessible.role: Accessible.Button
    Accessible.name: root.text !== "" ? root.text : (root.toolTipText !== "" ? root.toolTipText : qsTr("Activity action button"))
    Accessible.onPressAction: root.clicked()

    Label {
        id: label
        visible: root.text !== ""
        text: root.text
        font.underline: true
        color: root.hovered ? root.textColorHovered : root.textColor
        anchors.centerIn: parent
        width: parent.width

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    ToolTip {
        text: root.toolTipText
        delay: 1000
        visible: root.toolTipText !== "" && root.hovered
    }

    MouseArea {
        id: mouseArea
        anchors.fill: label
        onClicked: root.clicked()
        hoverEnabled: true
    }
}
