include(../libs.pri)

TEMPLATE = app
TARGET = atromio

QT += qml quick widgets core sql

CONFIG += console c++11 ordered

VERSION = 0.0.1

DEFINES += A_APP_VERSION_STR=\\\"$$VERSION\\\"

SOURCES += main.cpp

RESOURCES += qml.qrc

DESTDIR = $$top_builddir

QMAKE_SUBSTITUTES = version.info.in
