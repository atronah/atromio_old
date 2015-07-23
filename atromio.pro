TEMPLATE = app
TARGET = atromio

QT += qml quick widgets core sql

CONFIG += console

VERSION = 0.0.1

DEFINES = A_APP_VERSION_STR=\\\"$$VERSION\\\"

SOURCES += \
    src/main.cpp \
    src/test.cpp

RESOURCES += qml.qrc
INCLUDEPATH += include

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS +=
