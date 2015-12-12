TEMPLATE = lib
TARGET = core
QT += core
QT -= gui
CONFIG += staticlib

INCLUDEPATH += include

DESTDIR = $$top_builddir/libs

HEADERS = include/Currency.h

SOURCES = src/Currency.cpp



