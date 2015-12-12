TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS = core app

#CONFIG(debug, debug|release) {
#    SUBDIRS += tests
#}

app.depends = core
#tests.depends = core

#DISTFILES += README LICENSE
