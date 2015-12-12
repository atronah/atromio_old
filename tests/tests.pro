include(../libs.pri)
TEMPLATE = app
TARGET = run_tests

QT += testlib

CONFIG += testcase

HEADERS += TestCurrency.h \
    AutoTest.h
SOURCES += TestCurrency.cpp \
    main.cpp

DESTDIR = $$top_builddir
