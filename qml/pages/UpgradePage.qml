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
                histUpgradeModel.clear()
                console.log("Hist. Entires: "+Storage.loadUpgrades(hero.heroID))
                uid = 0

                hero.heroChanged = false
            }
        }
        toSlider.value = 2
    }

    function save() {
        console.log("Saving "+hero.heroName)
        console.log(Storage.saveHero(hero.heroID, hero.heroName, hero.availableAp, hero.usedAp))

        if(upgradeModel.count > 0){
            var row
            var log
            for(var i=upgradeModel.count-1;i>=0;i--){
                row = upgradeModel.get(i)
//                console.log(JSON.stringify(row, null, 1))
                log = row.log.toString()
                Storage.saveUpgrades(hero.heroID, row.ap, row.note+' '+log.substring(4)+' '+row.ap+qsTr(" EPs"))
            }
            upgradeModel.clear()
            histUpgradeModel.clear()
            Storage.loadUpgrades(hero.heroID)
            uid = 0
        }
    }

    function getCost(cFrom, cTo){
        if(hero.rules === 0){
            apCost = Logic.upgardeCost(upgradeColumn4.currentIndex-1, cFrom, cTo)
        }else{
            apCost = Logic.upgardeCost5(upgradeColumn5.currentIndex-1, cFrom, cTo)
        }
    }

    ListModel {
        id: upgradeModel
    }
    ListModel {
        id: histUpgradeModel
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: heroView.height + histUpgradeList.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                visible: uid != 0
                text: qsTr("Clear all")
                onClicked: {
                    uid = 0
                    upgradeModel.clear()
                    Storage.loadHero(hero.heroID)
                }
            }
            MenuItem {
                text: qsTr("Save hero")
                visible: hero.heroID !== -1
                onClicked: save()
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

                    if(toSlider.value <= fromSlider.value){
                        toSlider.value = value + 1
                    }
                    getCost(fromSlider.value, toSlider.value)
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
                    if(toSlider.value <= fromSlider.value){
                        fromSlider.value = value - 1
                    }
                    getCost(fromSlider.value, toSlider.value)
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
                EnterKey.onClicked: note.focus = true
            }

            TextField {
                id: note
                width: parent.width

                label: qsTr("Note")+":"

                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false
            }

            Button {
                id: upgradeButton

                anchors.horizontalCenter: parent.horizontalCenter
                text: hero.availableAp - apCost >= 0 ? qsTr("Upgrade for ") + apCost + qsTr(" EP") : qsTr("Not enough EPs")

                onClicked: {
                    if(apCost === 0){
                        return
                    }

                    if(hero.availableAp - hero.usedAp - apCost >= 0){
                        var log = ""
                        hero.usedAp = hero.usedAp + apCost
                        uid++
                        if(showSlider){
                            var col = ''
                            if(hero.rules === 0){
                                col = upgradeColumn4.currentIndex === 1 ? "A+": upgradeColumn4.value.charAt(0)
                            }
                            else{
                                col = upgradeColumn5.value.charAt(0)
                            }

                            log = (uid <= 9 ? "0":"") + uid + ": " + qsTr("Column ") + col + qsTr(" from ") + fromSlider.value + qsTr(" to ") + toSlider.value + " -> "

                        }else{
                            var logText = note.text === ""?qsTr("Non skill"):note.text
                            note.text = ""
                            log = (uid <= 9 ? "0":"") + uid + ": "+ logText + qsTr(" for ")
                        }
                        upgradeModel.insert(0,{"log": log, "ap": apCost, "note": note.text})
                        note.text = ""
                    }
                }
            }

            SilicaListView {
                id: upgradeList
                width: parent.width
                height: Theme.fontSizeMedium*3*(upgradeModel.count>4?4:upgradeModel.count)
                clip: true
                VerticalScrollDecorator {}

                model: upgradeModel

                delegate: ListItem {
                    id: upgradeItem
                    width: parent.width
                    contentHeight: logEntry.height + (logNote.text === "" ? 0:logNote.height)
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
                        width: parent.width
                        text:  log + ap + qsTr(" EPs")
                        color: upgradeItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                        font.pixelSize: Theme.fontSizeMedium
                    }
                    Label {
                        id: logNote
                        anchors.top: logEntry.bottom
                        width: parent.width
                        text:  note
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

            Label {
                text: qsTr("Previous Upgrades")
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.primaryColor
                visible: histUpgradeModel.count > 0
            }
        }

        SilicaListView {
            id: histUpgradeList
            anchors.top: heroView.bottom
            anchors.topMargin: Theme.paddingSmall
            width: page.width-2*Theme.paddingMedium
            x: Theme.paddingMedium
            height: page.heigt > (heroView.height+5*Theme.fontSizeMedium*1.3) ? (page.height-heroView.height-Theme.paddingSmall):(histUpgradeModel.count > 10 ? 10:histUpgradeModel.count)*Theme.fontSizeMedium*1.3
            model: histUpgradeModel
            clip: true
            VerticalScrollDecorator {}

            delegate: ListItem {
                id: histDeligate
                width: ListView.view.width
                contentHeight: histLogEntry.height

                Text {
                    id: histLogEntry

                    property var locale: Qt.locale()
                    property date mDate: Date.fromLocaleString(locale, date, "yyyy-MM-dd hh:mm:ss")
                    property string upgradeDate: mDate.toLocaleDateString(locale, Locale.ShortFormat)

                    width: parent.width
                    text:  upgradeDate + " " + note
                    wrapMode: Text.Wrap
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                }
            }
        }
    }
}
