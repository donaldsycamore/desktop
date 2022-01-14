import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Style 1.0
import com.nextcloud.desktopclient 1.0

RowLayout {
    id: root

    property variant activityData: ({})

    property color activityTextTitleColor: Style.ncTextColor

    signal shareButtonClicked()

    spacing: 5

    Image {
        id: activityIcon
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        verticalAlignment: Qt.AlignCenter
        source: icon
        sourceSize.height: 64
        sourceSize.width: 64
    }

    Column {
        id: activityTextColumn
        Layout.topMargin: 4
        Layout.bottomMargin: 4
        Layout.fillWidth: true
        spacing: 4
        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

        Text {
            id: activityTextTitle
            text: (root.activityData.type === "Activity" || root.activityData.type === "Notification") ? root.activityData.subject : root.activityData.message
            width: parent.width
            elide: Text.ElideRight
            font.pixelSize: Style.topLinePixelSize
            color: root.activityData.activityTextTitleColor
        }

        Text {
            id: activityTextInfo
            text: (root.activityData.type === "Sync") ? root.activityData.displayPath
                                    : (root.activityData.type === "File") ? root.activityData.subject
                                                        : (root.activityData.type === "Notification") ? root.activityData.message
                                                                                    : ""
            height: (text === "") ? 0 : activityTextTitle.height
            width: parent.width
            elide: Text.ElideRight
            font.pixelSize: Style.subLinePixelSize
        }

        Text {
            id: activityTextDateTime
            text: root.activityData.dateTime
            height: (text === "") ? 0 : activityTextTitle.height
            width: parent.width
            elide: Text.ElideRight
            font.pixelSize: Style.subLinePixelSize
            color: "#808080"
        }
    }

    CustomButton {
        id: shareButton

        Layout.preferredWidth: 40
        Layout.preferredHeight: 40

        visible: root.activityData.isShareable

        imageSource: "image://svgimage-custom-color/share.svg" + "/" + Style.ncBlue
        imageSourceHover: "image://svgimage-custom-color/share.svg" + "/" + Style.ncTextColor

        toolTipText: qsTr("Open share dialog")

        textColor: root.textColor
        textColorHovered: root.textColorHovered

        bgColor: Style.ncBlue

        onClicked: root.shareButtonClicked()
    }
}
