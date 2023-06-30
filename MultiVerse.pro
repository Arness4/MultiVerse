QT += quick quickcontrols2 sql

win32:VERSION = 1.0.0.1
else: VERSION = 1.0.0

SOURCES += \
        main.cpp \
        model/biblemanager.cpp \
        model/biblerepo.cpp \
        model/config.cpp \
        model/model.cpp \
        model/searchrepo.cpp \
        model/verse.cpp \
        model/verserepo.cpp

resources.files = qml/windows/main.qml qml/component/BToolBar.qml qml/windows/RemoteDialog.qml qml/windows/Live.qml qml/component/BMenuBar.qml qml/component/Sidebar.qml qml/component/BAction.qml
resources.prefix = /$${TARGET}
RESOURCES += resources \
    assets.qrc

TRANSLATIONS += \
    translations/baiboly_en_US.ts  translations/baiboly_fr_FR.ts  translations/baiboly_mg_MG.ts
CONFIG += lrelease
CONFIG += embed_translations

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =


# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    model/biblemanager.h \
    model/biblerepo.h \
    model/config.h \
    model/model.h \
    model/searchrepo.h \
    model/verse.h \
    model/verserepo.h \
    translator.h

RC_ICONS = bible4.ico



