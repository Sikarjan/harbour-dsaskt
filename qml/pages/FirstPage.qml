/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/logic.js" as Logic


Page {
    id: page

    property int apCost: 0
    property int uid: 0

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
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                visible: uid != 0
                text: qsTr("Clear all")
                onClicked: {
                    apCost = 0
                    uid = 0
                    hero.availableAp = 0
                    hero.usedAp = 0
                    upgradeModel.clear()
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: page.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            //anchors.fill: parent
            spacing: 0 //Theme.paddingSmall
            PageHeader {
                title: qsTr("DSA SKT")
            }

            Row {
                id: titleRow
                width: page.width

                TextField {
                    id: availableApField
                    width: page.width/2

                    placeholderText: qsTr("Enter your APs")
                    text: hero.availableAp === 0 ? "" : hero.availableAp.toString()
                    inputMethodHints: Qt.ImhDigitsOnly
                    validator: IntValidator { bottom: 0; top: 99999 }
                    label: qsTr("Available APs")

                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    EnterKey.onClicked: upgradeColumn.focus = true

                    onTextChanged: hero.availableAp = text*1
                }

                TextField {
                    id: usedApField
                    width: page.width/2

                    readOnly: true
                    horizontalAlignment: TextInput.AlignRight
                    text: hero.usedAp === 0 ? "" : hero.usedAp + " AP"
                    label: qsTr("Used APs")
                }
            }

            ComboBox {
                id: upgradeColumn
                width: parent.width
                label: qsTr("Column:")
                currentIndex: 2

                menu: ContextMenu {
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

                onCurrentIndexChanged: apCost = Logic.upgardeCost(upgradeColumn.currentIndex, fromSlider.value, toSlider.value)
            }

            Slider {
                id: fromSlider
                width: parent.width
                label: qsTr("Current Value:")
                value: 1
                minimumValue: 1
                maximumValue: 30
                stepSize: 1
                valueText: value

                onValueChanged: {
                    toSlider.minimumValue = value + 1
                    toSlider.value = value + 1
                }
            }


            Slider {
                id: toSlider
                width: parent.width
                label: qsTr("Upgrade Value:")
                value: 1
                minimumValue: 1
                maximumValue: 31
                stepSize: 1
                valueText: value

                onValueChanged: apCost = Logic.upgardeCost(upgradeColumn.currentIndex, fromSlider.value, toSlider.value)
            }

            Button {
                id: upgradeButton

                visible: apCost != 0 && hero.availableAp != 0
                anchors.horizontalCenter: parent.horizontalCenter
                text: hero.availableAp - apCost >= 0 ? qsTr("Upgrade for ") + apCost + " AP" : qsTr("Not enough APs")

                onClicked: {
                    if(hero.availableAp - apCost >= 0){
                        hero.availableAp = hero.availableAp - apCost
                        hero.usedAp = hero.usedAp + apCost
                        uid++
                        var col = upgradeColumn.currentIndex === 0 ? "A+": upgradeColumn.value.charAt(0)
                        var log = (uid <= 9 ? "0":"") + uid + ": " + qsTr("Column ") + col + qsTr(" from ") + fromSlider.value + qsTr(" to ") + toSlider.value + " -> "
                        upgradeModel.insert(0,{"log": log, "ap": apCost})
                    }
                }
            }

        }

        SilicaListView {
            id: upgradeList
            width: page.width
            height: page.height - column.height
            anchors.top: column.bottom
            clip: true

            model: upgradeModel

            delegate: ListItem {
                id: upgradeItem
                width: ListView.view.width
                contentHeight: logEntry.height
                ListView.onRemove: animateRemoval(upgradeItem)

                function remove() {
                    var remorse = remorseAction(qsTr("Deleting upgrade"), function() {
                        hero.availableAp = hero.availableAp + upgradeList.model.get(index).ap
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
                    text:  log + ap + " APs"
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


