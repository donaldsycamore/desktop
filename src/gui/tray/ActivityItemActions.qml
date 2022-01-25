import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Style 1.0

RowLayout {
    id: root

    spacing: 20

    property string objectType: ""
    property variant activityLinks: []
    property bool displayActions: false

    property color moreActionsButtonColor: "transparent"

    property int maxActionButtons: 0

    property Flickable flickable

    signal triggerAction(int actionIndex)

    function actionButtonIcon(actionIndex, color) {
        const verb = String(root.activityLinks[actionIndex].verb);
        const objectType = String(root.objectType);
        if (verb === "WEB" && (objectType === "chat" || objectType === "call" || objectType === "room")) {
            return "image://svgimage-custom-color/reply.svg" + "/" + color;
        }

        return "";
    }

    function actionButtonText(actionIndex) {
        const verb = String(root.activityLinks[actionIndex].verb);
        const objectType = String(root.objectType);
        if (verb === "DELETE") {
            return qsTr("Mark as read")
        } else if (verb === "WEB" && objectType !== "room" && (objectType === "chat" || objectType !== "call")) {
            return qsTr("Reply")
        }

        return root.activityLinks[actionIndex].label;
    }

    Repeater {
        // a max of maxActionButtons can will get dispayed as separate buttons
        model: root.activityLinks.length > root.maxActionButtons ? 1 : root.activityLinks.length

        ActivityActionButton {
            id: activityActionButton

            readonly property int actionIndex: model.index
            readonly property bool primary: model.index === 0 && root.activityLinks[actionIndex].verb !== "DELETE"

            Layout.minimumWidth: primary ? 100 : 80
            Layout.preferredHeight: parent.height
            Layout.preferredWidth: primary ? -1 : parent.height
            Layout.fillHeight: true

            text: root.actionButtonText(actionIndex)
            toolTipText: root.activityLinks[actionIndex].label

            imageSource: root.actionButtonIcon(actionIndex, Style.ncBlue)
            imageSourceHover: root.actionButtonIcon(actionIndex, Style.ncTextColor)

            textColor: imageSource !== "" ? Style.ncBlue : Style.unifiedSearchResulSublineColor
            textColorHovered: imageSource !== "" ? Style.lightHover : Style.unifiedSearchResulTitleColor

            bold: primary

            onClicked: root.triggerAction(actionIndex)
        }
    }

    Loader {
        // actions that do not fit maxActionButtons limit, must be put into a context menu
        id: moreActionsButtonContainer

        Layout.preferredWidth: parent.height
        Layout.fillHeight: true

        active: root.displayActions && (root.activityLinks.length > root.maxActionButtons)

        sourceComponent: Button {
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

                anchors.right: moreActionsButton.right
                anchors.top: moreActionsButton.top

                maxActionButtons: root.maxActionButtons
                activityItemLinks: root.activityLinks

                onMenuEntryTriggered: function(entryIndex) {
                    root.triggerAction(entryIndex)
                }
            }
        }
    }
}
