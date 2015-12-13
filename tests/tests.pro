include(../libs.pri)
TEMPLATE = app
TARGET = run_tests

QT += testlib

#CONFIG += testcase
CONFIG += c++11

HEADERS += TestCurrency.h \
    AutoTest.h \
    TestMoney.h
SOURCES += TestCurrency.cpp \
    main.cpp \
    TestMoney.cpp

DESTDIR = $$top_builddir

DEFINES += A_TEST_DEL
