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

    Repeater {
        id: actionsRepeater
        // a max of maxActionButtons can will get dispayed as separate buttons
        model: transformActivityLinks(root.activityLinks)

        function transformActivityLinks(links) {
            if (links.length === 0) {
                return links;
            }

            function createNewVerbAndImageForLink(link) {
                var image = ""
                var imageHovered = ""
                var newLabel = link.label

                const verb = String(link.verb);
                const objectType = String(root.objectType);

                // pick proper icon
                if (verb === "WEB" && (objectType === "chat" || objectType === "call" || objectType === "room")) {
                    image = "image://svgimage-custom-color/reply.svg" + "/" + Style.ncBlue;
                    imageHovered = "image://svgimage-custom-color/reply.svg" + "/" + Style.ncTextColor;
                }

                // pick proper label
                if (verb === "DELETE") {
                    newLabel = qsTr("Mark as read")
                } else if (verb === "WEB" && objectType !== "room" && (objectType === "chat" || objectType !== "call")) {
                    newLabel = qsTr("Reply")
                }

                return { label: newLabel, imageSource: image, imageSourceHovered: imageHovered }
            }

            if (links.length > root.maxActionButtons) {
                return [(Object.assign({}, links[0], createNewVerbAndImageForLink(links[0])))];
            }

            var reduceLinks = links.reduce(function(reduced, link, index) {
                const linkWithIconAndLabel = Object.assign({}, link, createNewVerbAndImageForLink(link));
                reduced.push(linkWithIconAndLabel);
                return reduced;
            }, []);

            return reduceLinks;
        }

        ActivityActionButton {
            id: activityActionButton

            readonly property int actionIndex: model.index
            readonly property bool primary: model.index === 0 && model.modelData.verb !== "DELETE"

            Layout.minimumWidth: primary ? Style.activityItemActionPrimaryButtonMinWidth : Style.activityItemActionSecondaryButtonMinWidth
            Layout.preferredHeight: primary ? parent.height : parent.height * 0.3
            Layout.preferredWidth: primary ? -1 : parent.height

            text: model.modelData.label
            toolTipText: model.modelData.label

            imageSource: model.modelData.imageSource
            imageSourceHover: model.modelData.imageSourceHovered

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
            anchors.topMargin: Style.roundedButtonBackgroundVerticalMargins
            anchors.bottomMargin: Style.roundedButtonBackgroundVerticalMargins

            icon.source: "qrc:///client/theme/more.svg"

            background: Rectangle {
                color: parent.hovered ? "white" : root.moreActionsButtonColor
                radius: 25
            }

            ToolTip.visible: hovered
            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.text: qsTr("Show more actions")

            Accessible.name: qsTr("Show more actions")

            onClicked:  function() {
                moreActionsButtonContextMenu.popup(moreActionsButton.x, moreActionsButton.y);
            }

            Connections {
                target: root.flickable

                function onMovementStarted() {
                    moreActionsButtonContextMenu.close();
                }
            }

            ActivityItemContextMenu {
                id: moreActionsButtonContextMenu

                maxActionButtons: root.maxActionButtons
                activityItemLinks: root.activityLinks

                onMenuEntryTriggered: function(entryIndex) {
                    root.triggerAction(entryIndex)
                }
            }
        }
    }
}
