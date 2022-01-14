import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Style 1.0

Button {
    id: root

    property string imageSource: ""
    property string imageSourceHover: ""

    property string toolTipText: ""

    property color textColor: ({})
    property color textColorHovered: ({})

    property color bgColor: "transparent"

    Accessible.role: Accessible.Button
    Accessible.name: text !== "" ? text : (toolTipText !== "" ? toolTipText : qsTr("Activity action button"))
    Accessible.onPressAction: clicked()


    background: Rectangle {
        anchors.fill: parent
        color: root.bgColor
        opacity: parent.hovered ? 1.0 : 0.3
        radius: 25
    }

    contentItem: RowLayout {
        anchors.centerIn: parent
        Image {
            id: icon

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            source: root.hovered ? root.imageSourceHover : root.imageSource
        }
        Text { 
            Layout.fillWidth: icon.status !== Image.Ready

            text: root.text
            font: root.font

            visible: root.text !== ""

            color: root.hovered ? root.textColorHovered : root.textColor

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            elide: Text.ElideRight
        }
    }

    ToolTip {
        text: root.toolTipText
        delay: 1000
        visible: root.toolTipText !== "" && root.hovered
    }
}
