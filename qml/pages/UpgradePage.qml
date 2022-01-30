import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

import "../js/storage.js" as Storage
import "../js/logic.js" as Logic
import "../components"


Page {
    id: page

    property int apCost: 0
    property int uid: 0
    property bool showSlider: true

    // Manage Heros
    onStatusChanged: {
        if(status === PageStatus.Active) {
            if(hero.heroID !== -1 && hero.heroChanged) {
                console.log("Loading Hero: "+hero.heroID)
                Storage.loadHero(hero.heroID)
                upgradeModel.clear()
                uid = 0

                hero.heroChanged = false
            }
        }
    }

    function save() {
        console.log("Saving "+hero.heroName)
        console.log(Storage.saveHero(hero.heroID, hero.heroName, hero.availableAp, hero.usedAp))
    }

    ListModel {
        id: upgradeModel
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        VerticalScrollDecorator { flickable: upgradeList }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Save hero")
                visible: hero.heroID !== -1
                onClicked: save()
            }
            MenuItem {
                visible: uid != 0
                text: qsTr("Clear all")
                onClicked: {
                    uid = 0
                    upgradeModel.clear()
                    Storage.loadHero(hero.heroID)
                }
            }
        }

        // Hero upgrade Column
        Column {
            id: heroView
            width: page.width-2*Theme.paddingMedium
            x: Theme.paddingMedium
            spacing: Theme.paddingSmall
            visible: hero.heroID !== -1

            PageHeader {
                id: header
                title: qsTr("DSA SKT")
            }

            Row {
                id: nameRow
                width: parent.width-2*Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: nameLabel
                    text: hero.heroName
                    width: parent.width/2
                }

                Label {
                    id: ruleLabel
                    text: qsTr("rules: ") + (hero.rules === 0 ? '4.1':'5.0')
                    width: parent.width/2

                    horizontalAlignment: TextInput.AlignRight
                }
            }

            Row {
                id: titleRow
                width: parent.width

                TextField {
                    id: availableApField
                    width: parent.width*0.4

                    text: hero.availableAp
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0; top: 99999 }
                    label: qsTr("Available EPs")

                    onTextChanged: hero.availableAp = text*1
                }

                Label {
                    id: feeApField
                    width: parent.width*0.2
                    text: hero.availableAp - hero.usedAp
                    horizontalAlignment: Text.AlignHCenter
                }

                TextField {
                    id: usedApField
                    width: parent.width*0.4

                    horizontalAlignment: TextInput.AlignRight
                    text: hero.usedAp
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0; top: 99999 }
                    label: qsTr("Used EPs")

                    onTextChanged: hero.usedAp = text*1
                }
            }

            ComboBox {
                id: upgradeColumn4
                visible: hero.rules === 0
                width: parent.width
                label: qsTr("Column:")
                currentIndex: 2

                menu: ContextMenu {
                    MenuItem { text: qsTr("Non skills") }
                    MenuItem { text: qsTr("A+: Special upgrades")}
                    MenuItem { text: qsTr("A: Languages")}
                    MenuItem { text: qsTr("B: Non body skills")}
                    MenuItem { text: qsTr("C: Fighting skills")}
                    MenuItem { text: qsTr("D: Body skills")}
                    MenuItem { text: "E: AU"}
                    MenuItem { text: qsTr("F: Gifts")}
                    MenuItem { text: "G: AE"}
                    MenuItem { text: qsTr("H: Properties, LE, MR")}
                }

                onCurrentIndexChanged: {
                    apCost = 0
                    if(upgradeColumn4.currentIndex == 0){
                        showSlider = false
                    }else{
                        apCost = Logic.upgardeCost(upgradeColumn4.currentIndex-1, fromSlider.value, toSlider.value)
                        showSlider = true
                    }
                }
            }

            ComboBox {
                id: upgradeColumn5
                visible: hero.rules === 1
                width: parent.width
                label: qsTr("Column:")
                currentIndex: 2

                menu: ContextMenu {
                    MenuItem { text: qsTr("Non skills") }
                    MenuItem { text: "A: " + qsTr("Skills")}
                    MenuItem { text: "B: " + qsTr("Misc")}
                    MenuItem { text: "C: " + qsTr("Misc")}
                    MenuItem { text: "D: " + qsTr("Misc")}
                    MenuItem { text: "E: " + qsTr("Properties")}
                }

                onCurrentIndexChanged: {
                    apCost = 0
                    if(upgradeColumn5.currentIndex == 0){
                        showSlider = false
                    }else{
                        apCost = Logic.upgardeCost5(upgradeColumn5.currentIndex-1, fromSlider.value, toSlider.value)
                        showSlider = true
                    }
                }
            }

            ButtonSlider {
                id: fromSlider
                width: parent.width
                visible: showSlider
                label: qsTr("Current Value:")
                value: 1
                minimumValue: hero.rules === 0 ? -5:0
                maximumValue: 30
                stepSize: 1
//                valueText: value

                onValueChanged: {
                    toSlider.minimumValue = value + 1
                    toSlider.value = value + 1
                }
            }


            ButtonSlider {
                id: toSlider
                width: parent.width
                visible: showSlider
                label: qsTr("Upgrade Value:")
                value: 1
                minimumValue: hero.rules === 0 ? -4:0
                maximumValue: 31
                stepSize: 1
//                valueText: value

                onValueChanged: {
                    if(hero.rules === 0){
                        apCost = Logic.upgardeCost(upgradeColumn4.currentIndex-1, fromSlider.value, toSlider.value)
                    }else{
                        apCost = Logic.upgardeCost5(upgradeColumn5.currentIndex-1, fromSlider.value, toSlider.value)
                    }
                }
            }

            TextField {
                id: miscInput
                width: parent.width
                visible: !showSlider

                text: "0"
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 99999 }
                label: qsTr("Misc EX cost")

                onTextChanged: apCost = text*1
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: upgradeButton.focus = true
            }

            Button {
                id: upgradeButton

                visible: apCost != 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: hero.availableAp - apCost >= 0 ? qsTr("Upgrade for ") + apCost + qsTr(" EP") : qsTr("Not enough EPs")

                onClicked: {
                    if(hero.availableAp - hero.usedAp - apCost >= 0){
                        var log = ""
                        hero.usedAp = hero.usedAp + apCost
                        uid++
                        if(showSlider){
                            var col = upgradeColumn4.currentIndex === 1 ? "A+": upgradeColumn4.value.charAt(0)
                            log = (uid <= 9 ? "0":"") + uid + ": " + qsTr("Column ") + col + qsTr(" from ") + fromSlider.value + qsTr(" to ") + toSlider.value + " -> "

                        }else{
                            log = (uid <= 9 ? "0":"") + uid + ": "+qsTr("Non skill") + qsTr(" for ")
                        }
                        upgradeModel.insert(0,{"log": log, "ap": apCost})
                    }
                }
            }
        }

        SilicaListView {
            id: upgradeList
            width: page.width
            height: page.height - heroView.height - 2*Theme.paddingMedium
            anchors.top: heroView.bottom
            anchors.topMargin: Theme.paddingMedium
            clip: true

            model: upgradeModel

            delegate: ListItem {
                id: upgradeItem
                width: ListView.view.width
                contentHeight: logEntry.height
                ListView.onRemove: animateRemoval(upgradeItem)

                function remove() {
                    var remorse = remorseAction(qsTr("Deleting upgrade"), function() {
                        hero.usedAp = hero.usedAp - upgradeList.model.get(index).ap
                        upgradeList.model.remove(index)
                    });
                    remorse.canceled.connect(function() { logEntry.height = Theme.itemSizeSmall/1.8 })
                }

                  Label {
                    id: logEntry
                    height: Theme.itemSizeSmall/1.8
                    anchors {
                        left: parent.left
                        right: parent.right
                        leftMargin: Theme.paddingLarge
                    }
                    text:  log + ap + qsTr(" EPs")
                    color: upgradeItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Delete upgrade")
                        onClicked: {
                            logEntry.height = Theme.itemSizeSmall
                            remove()
                        }

                    }
                }
            }
        } // End ListView
    }
}
