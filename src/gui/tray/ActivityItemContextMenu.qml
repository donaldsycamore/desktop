import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.3

AutoSizingMenu {
    id: moreActionsButtonContextMenu

    property int maxActionButtons: 0

    property var activityItemLinks: []

    signal menuEntryTriggered(int index)

    // transform model to contain indexed actions with primary action filtered out
    function actionListToContextMenuList(actionList) {
        // early out with non-altered data
        if (actionList.length <= maxActionButtons) {
            return actionList;
        }

        // add index to every action and filter 'primary' action out
        var reducedActionList = actionList.reduce(function(reduced, action, index) {
            if (!action.primary) {
                var actionWithIndex = { actionIndex: index, label: action.label };
                reduced.push(actionWithIndex);
            }
            return reduced;
        }, []);


        return reducedActionList;
    }

    Repeater {
        id: moreActionsButtonContextMenuRepeater

        model: moreActionsButtonContextMenu.actionListToContextMenuList(activityItemLinks)

        delegate: MenuItem {
            id: moreActionsButtonContextMenuEntry
            text: model.modelData.label
            onTriggered: menuEntryTriggered(model.modelData.actionIndex)
        }
    }
}
