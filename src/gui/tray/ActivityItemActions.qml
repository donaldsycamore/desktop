import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Style 1.0
import com.nextcloud.desktopclient 1.0

RowLayout {
    id: root

    property variant activityData: ({})

    property color moreActionsButtonColor: "white"

    property int maxActionButtons: 0

    property bool isFileActivity: activityData.objectType === "files" && activityData.path !== ""

    property Flickable flickable: Flickable{}

    signal fileActivityButtonClicked(string absolutePath)
    signal triggerAction(int actionIndex)

    spacing: 20

    function actionButtonIcon(actionIndex, color) {
        const verb = String(root.activityData.links[actionIndex].verb);
        if (verb === "WEB" && (root.activityData.objectType === "chat" || root.activityData.objectType === "call")) {
            return "image://svgimage-custom-color/reply.svg" + "/" + color;
        }

        return "";
    }

    function actionButtonText(actionIndex) {
        const verb = String(root.activityData.links[actionIndex].verb);
        if (verb === "DELETE") {
            return qsTr("Mark as read")
        } else if (verb === "WEB" && (root.activityData.objectType === "chat" || root.activityData.objectType !== "call")) {
            return qsTr("Reply")
        }

        return root.activityData.links[actionIndex].label;
    }

    Repeater {
        model: root.activityData.links.length > root.maxActionButtons ? 1 : root.activityData.links.length

        ActivityActionButton {
            id: activityActionButton

            readonly property int actionIndex: model.index
            readonly property bool primary: model.index === 0 && String(root.activityData.links[actionIndex].verb) !== "DELETE"

            text: root.actionButtonText(actionIndex)
            toolTipText: root.activityData.links[actionIndex].label

            imageSource: root.actionButtonIcon(actionIndex, Style.ncBlue)
            imageSourceHover: root.actionButtonIcon(actionIndex, Style.ncTextColor)

            textColor: primary ? Style.ncBlue : "black"
            textColorHovered: Style.lightHover

            Layout.minimumWidth: primary ? 100 : 80
            Layout.minimumHeight: parent.height
            Layout.preferredWidth: primary ? -1 : parent.height
            Layout.fillHeight: true

            onClicked: root.triggerAction(actionIndex)
        }
    }

    ActivityActionButton {
        id: viewActivityButton

        visible: root.isFileActivity

        readonly property bool isDismissAction: true

        Layout.fillHeight: true

        text: qsTr("View activity")

        textColor: "black"
        textColorHovered: Style.lightHover

        toolTipText: qsTr("View activity")

        Layout.minimumWidth: 80
        Layout.minimumHeight: parent.height

        Layout.preferredWidth: parent.height

        onClicked: root.fileActivityButtonClicked(root.activityData.absolutePath)
    }

    Item {
        id: moreActionsButtonContainer

        Layout.preferredWidth: parent.height
        Layout.preferredHeight: parent.height

        visible: root.activityData.displayActions && (root.activityData.links.length > root.maxActionButtons)

        Button {
            id: moreActionsButton

            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10

            icon.source: "qrc:///client/theme/more.svg"

            background: Rectangle {
                color: parent.hovered ? "white" : root.moreActionsButtonColor
                radius: 25
            }

            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Show more actions")

            Accessible.role: Accessible.Button
            Accessible.name: qsTr("Show more actions")
            Accessible.onPressAction: moreActionsButton.clicked()

            onClicked:  moreActionsButtonContextMenuContainer.open();

            Connections {
                target: root.flickable

                function onMovementStarted() {
                    moreActionsButtonContextMenuContainer.close();
                }
            }

            ActivityItemContextMenu {
                id: moreActionsButtonContextMenuContainer

                visible: opened

                isFileActivity: root.isFileActivity

                anchors.right: moreActionsButton.right
                anchors.top: moreActionsButton.top

                maxActionButtons: root.maxActionButtons
                activityItemLinks: root.activityData.links

                onMenuEntryTriggered: function(entryIndex) {
                    root.triggerAction(entryIndex)
                }

                onFileActivityButtonClicked: root.fileActivityButtonClicked(root.activityData.absolutePath)
            }
        }

    }
}
