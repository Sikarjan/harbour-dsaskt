import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        VerticalScrollDecorator { }

        Column {
            id: column
            width: parent.width - 2*Theme.paddingMedium
            x: Theme.paddingMedium

            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("About DSA SKT")
            }

            Label {
                text: "Version: 1.2"
            }

            Text {
                font.pixelSize: Theme.fontSizeSmall
                width: column.width
                color: Theme.primaryColor
                wrapMode: Text.Wrap
                text: qsTr("This app calculates the required experience points to upgrade a skill, spell or attribute. First you need to create a new hero via the pull down menu. Choose a name and the rule set you want to use for upgrading as well as the current and used experience of this hero.
    In the upgrade page choose the correct column or ‘Non skill’ in case you want to enter direct costs. Then choose from where to where you improve a skill. Hit the upgrade button to execute the upgrade. To undo and upgrade delete the upgrade from the log list or chose the clear all option from the pull down menu.
    To save the changes to your hero use the save option from the pull down menu. You can always change the available and used experience points by tapping on them.")
            }

            Text {
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                textFormat: Text.RichText
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                text: qsTr("Please send me an email for feedback or improvement ideas.")
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                text: qsTr("Get in touch");
                onClicked: {
                    Qt.openUrlExternally("mailto:store@innobiz.de");
                }
            }
        }
    }
}
