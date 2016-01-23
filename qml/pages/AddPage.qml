import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "../js/storage.js" as Storage

Dialog {
    id: page
    acceptDestination: Qt.resolvedUrl("UpgradePage.qml")
    acceptDestinationAction: PageStackAction.Replace

    canAccept: {nameInput.text.length > 0}
    onAccepted: {
        Storage.initialize();
        hero.heroID = Storage.addHero(nameInput.text, ruleBox.currentIndex, availableApField.text, usedApField.text);
        hero.heroChanged = true;
    }

    SilicaFlickable {
        anchors.fill: parent

        DialogHeader {
            id: header
            title: qsTr("Settings")
            acceptText: qsTr("save")
            cancelText: qsTr("cancel")
        }

        Column {
            id: column
            width: parent.width - 2*Theme.paddingLarge
            anchors.top: header.bottom
            anchors.verticalCenter: parent.verticalCenter

            TextField {
                id: nameInput
                width: parent.width
                placeholderText: qsTr("Insert hero a name")
                label: qsTr("Hero name")
                validator: RegExpValidator { regExp: /[öäüÖÄÜ \w]+$/ }

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: availableApField.focus = true
            }

            ComboBox {
                id: ruleBox
                width: parent.width
                label: qsTr("Upgrade rules")

                menu: ContextMenu {
                    MenuItem { text: qsTr("Dark Eye")+" 4.1" }
                    MenuItem { text: qsTr("Dark Eye")+" 5.0" }
                }
            }

            TextField {
                id: availableApField
                width: page.width/2

                placeholderText: qsTr("Enter your EPs")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 99999 }
                label: qsTr("Hero's experience")

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: usedApField.focus = true

                onTextChanged: hero.availableAp = text*1
            }

            TextField {
                id: usedApField
                width: page.width/2

                placeholderText: qsTr("Enter used EPs")
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 99999 }
                label: qsTr("Used experience")

                onTextChanged: hero.availableAp = text*1
            }
        }
    }
}
