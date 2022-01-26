import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2

Button {
    id: root

    property string imageSource: ""
    property string imageSourceHover: ""

    property string toolTipText: ""

    property color textColor
    property color textColorHovered

    property color bgColor: "transparent"

    property bool bold: false

    background: Rectangle {
        color: root.bgColor
        opacity: parent.hovered ? 1.0 : 0.3
        radius: 25
    }

    leftPadding: root.text === "" ? 5 : 10
    rightPadding: root.text === "" ? 5 : 10

    contentItem: RowLayout {
        Image {
            id: icon

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            source: root.hovered ? root.imageSourceHover : root.imageSource
        }

        Label {
            Layout.maximumWidth: icon.width > 0 ? parent.width - icon.width - parent.spacing : parent.width
            Layout.fillWidth: icon.status !== Image.Ready

            text: root.text
            font.bold: root.bold

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
