import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import Style 1.0
import com.nextcloud.desktopclient 1.0

MouseArea {
    id: root

    readonly property int maxActionButtons: 2
    property Flickable flickable

    property bool isFileActivityList: false

    height: childrenRect.height

    signal fileActivityButtonClicked(string absolutePath)

    enabled: (model.path !== "" || model.link !== "")
    hoverEnabled: true

    Accessible.role: Accessible.ListItem
    Accessible.name: model.path !== "" ? qsTr("Open %1 locally").arg(model.displayPath)
                                       : model.message
    Accessible.onPressAction: root.clicked()

    ToolTip.visible: containsMouse && model.displayLocation !== ""
    ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
    ToolTip.text: qsTr("In %1").arg(model.displayLocation)

    Rectangle {
        id: activityHover
        anchors.fill: parent
        color: (parent.containsMouse ? Style.lightHover : "transparent")
    }

    ColumnLayout {
        anchors.left: root.left
        anchors.right: root.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 5

        ActivityItemContent {
            id: activityContent

            activityData: model

            onShareButtonClicked: Systray.openShareDialog(model.displayPath, model.absolutePath)

            Layout.fillWidth: true
        }

        ActivityItemActions {
            id: activityActions

            visible: !root.isFileActivityList && (model.links.length > 0 || activityActions.isFileActivity)

            Layout.preferredHeight: Style.trayWindowHeaderHeight
            Layout.fillHeight: true
            Layout.fillWidth: true

            isFileActivityList: root.isFileActivityList

            isFileActivity: model.objectType === "files" && model.path !== ""

            activityData: model

            moreActionsButtonColor: activityHover.color
            maxActionButtons: root.maxActionButtons
            flickable: root.flickable

            onTriggerAction: function(actionIndex) {
                activityModel.triggerAction(model.index, actionIndex)
            }

            onFileActivityButtonClicked: function(absolutePath) {
                root.fileActivityButtonClicked(absolutePath)
            }
        }
    }
}
