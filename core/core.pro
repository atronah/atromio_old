TEMPLATE = lib
TARGET = core
QT += core
QT -= gui
CONFIG += staticlib c++11

INCLUDEPATH += include

DESTDIR = $$top_builddir/libs

HEADERS = include/Currency.h \
    include/Money.h

SOURCES = src/Currency.cpp \
    src/Money.cpp



