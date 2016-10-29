TEMPLATE = lib
TARGET = core
QT += core sql
QT -= gui
CONFIG += staticlib c++11

INCLUDEPATH += include

DESTDIR = $$top_builddir/libs

HEADERS = include/Currency.h \
    include/Money.h \
    include/Controller.h

SOURCES = src/Currency.cpp \
    src/Money.cpp \
    src/Controller.cpp

DEFINES += A_TEST_DEL



