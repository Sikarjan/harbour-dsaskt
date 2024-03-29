# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-dsaskt

CONFIG += sailfishapp

SOURCES += src/harbour-dsaskt.cpp

OTHER_FILES += qml/harbour-dsaskt.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-dsaskt.changes.in \
    rpm/harbour-dsaskt.spec \
    rpm/harbour-dsaskt.yaml \
    translations/*.ts \
    harbour-dsaskt.desktop \
    qml/pages/AboutPage.qml \
    qml/js/logic.js

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-dsaskt-de.ts

RESOURCES += \
    res.qrc

DISTFILES += \
    qml/components/ButtonSlider.qml \
    qml/js/storage.js \
    qml/pages/AddPage.qml \
    qml/pages/UpgradePage.qml

