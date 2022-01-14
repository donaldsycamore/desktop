import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Style 1.0

Item {
    id: root

    property string text: ""
    property string toolTipText: ""

    property string imageSource: ""
    property string imageSourceHover: ""

    property color textColor: Style.ncTextColor
    property color textColorHovered: Style.lightHover

    signal clicked()

    Loader {
        active: root.imageSource === ""

        anchors.fill: parent

        sourceComponent: CustomTextButton {
             anchors.fill: parent
             text: root.text
             toolTipText: root.toolTipText

             onClicked: root.clicked()
        }
    }

    Loader {
        active: root.imageSource !== ""

        anchors.fill: parent

        sourceComponent: CustomButton {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            text: root.text
            toolTipText: root.toolTipText

            textColor: root.textColor
            textColorHovered: root.textColorHovered

            imageSource: root.imageSource
            imageSourceHover: root.imageSourceHover

            bgColor: Style.ncBlue

            onClicked: root.clicked()
        }
    }
}
