include(../libs.pri)

TEMPLATE = app
TARGET = atromio

QT += qml quick widgets core sql

CONFIG += console c++11 ordered

VERSION = 0.0.1

DEFINES += A_APP_VERSION_STR=\\\"$$VERSION\\\" \
           A_APP_VERSION_DATE_STR=\\\"\\\" \
           A_TEST_DEL

SOURCES += main.cpp

RESOURCES += qml.qrc

DESTDIR = $$top_builddir

# to rebuild libraries after changes
PRE_TARGETDEPS += $${files($$top_builddir/libs/*)}

#add version.info file into build dir with replaces variables
QMAKE_SUBSTITUTES = version.info.in

#rules for copying database files into  build/run directory
#DB_FILES = $${top_srcdir}/db/sqlite/data.db\
#           $${top_srcdir}/db/mysql/mysql_init.sql\
#copy_db.input = DB_FILES
#copy_db.output = $${top_builddir}/${QMAKE_FILE_BASE}${QMAKE_FILE_EXT}
#copy_db.commands = ${COPY_FILE} ${QMAKE_FILE_IN} ${QMAKE_FILE_OUT}
#copy_db.CONFIG += no_link target_predeps
#QMAKE_EXTRA_COMPILERS += copy_db

#rules for copying translation files into  build/run directory
LANG_FILES = $$files($${top_srcdir}/i18n/*.qm)
copy_lang.input = LANG_FILES
copy_lang.output = $${top_builddir}/i18n/${QMAKE_FILE_BASE}${QMAKE_FILE_EXT}
copy_lang.commands = ${COPY_FILE} ${QMAKE_FILE_IN} ${QMAKE_FILE_OUT}
copy_lang.CONFIG += no_link target_predeps
QMAKE_EXTRA_COMPILERS += copy_lang
