/**************************************************************************
**  Copyright 2015 atronah.
**
**  This file is part of the  program.
**
**  atromio is free software: you can redistribute it and/or modify
**  it under the terms of the GNU Lesser General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**  atromio is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU Lesser General Public License for more details.
**
**  You should have received a copy of the GNU Lesser General Public License
**  along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
**  (Это свободная программа: вы можете перераспространять ее и/или изменять
**  ее на условиях GNU Lesser General Public License в том виде, в каком
**  она была опубликована Фондом свободного программного обеспечения; либо
**  версии 3 лицензии, либо (по вашему выбору) любой более поздней версии.
**
**  Эта программа распространяется в надежде, что она будет полезной,
**  но БЕЗО ВСЯКИХ ГАРАНТИЙ; даже без неявной гарантии ТОВАРНОГО ВИДА
**  или ПРИГОДНОСТИ ДЛЯ ОПРЕДЕЛЕННЫХ ЦЕЛЕЙ. Подробнее см. в GNU Lesser General Public License.
**
**  Вы должны были получить копию GNU Lesser General Public License
**  вместе с этой программой. Если это не так, см.
**  <http://www.gnu.org/licenses/>.)
**************************************************************************/
/*
  File   :
  Created: 7/22/2015
  Reason : for test code
  Product: atromio
  Author : atronah

*/


#include <iostream>

#include <QCommandLineParser>
#include <QtSql/QSqlDatabase>
#include <QSharedPointer>
#include <QtSql/QSqlError>
#include <QtSql/QSqlQuery>
#include <QFileInfo>
#include <QTextStream>
#include <QDebug>
#include "Money.h"

namespace test{

    class SimpleException{
        const QString m_message;
    public:
        SimpleException(const QString &message) throw() : m_message(message) {}
        const QString & message() const {return m_message;}
    };

    class DatabaseError{
        QSharedPointer<QSqlError> m_dbError;
    public:
        DatabaseError(const QSqlError &dbError) throw() : m_dbError(new QSqlError(dbError)) {}
    };

    void processAttributes(){
        QCommandLineParser parser;
        parser.addHelpOption();
        parser.addVersionOption();

        QCommandLineOption initDatabase
                = QCommandLineOption("init-db",
                                     QCoreApplication::translate("command-line-opt",
                                                                 "initialize SQLite database in specified <file>"),
                                     QCoreApplication::translate("command-line-opt", "filename"));
        parser.addOption(initDatabase);

        parser.process(*qApp);

        if(parser.isSet(initDatabase)){
            initSQLiteDatabase(parser.value(initDatabase));
        }
    }




    int test(){
        qApp->setApplicationVersion(A_APP_VERSION_STR);

        processAttributes();

        return 0;
    }
}



