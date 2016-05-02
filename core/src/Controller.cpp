/**************************************************************************
**  Copyright 2016 .
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
  File   : src/Controller.cpp
  Created: 02.05.2016
  Reason : class for controlling app life
  Product: atromio
  Author : atronah
*/


#include "include/Controller.h"
#include <QDebug>
#include <QSqlError>
#include <QSqlQuery>
#include <QFile>

Controller::Controller(){
}


bool Controller::init_database(){
    m_db = QSqlDatabase::addDatabase("QSQLITE", "main");
    m_db.setDatabaseName("data.db");
    if(!m_db.open()){
        qWarning() << "cannot open database"
                   << m_db.lastError().driverText()
                   << m_db.lastError().databaseText();
    }
    QSqlQuery q(m_db);
    if (!m_db.tables().contains("DATABASECHANGELOG")){
        QFile scripts(":/db/sqlite/init.sql");
        if (!scripts.open(QFile::ReadOnly | QFile::Text)){
            qWarning() << "cannot open script file";
            return false;
        }
        QTextStream stream(&scripts);
        while (!stream.atEnd()){
            QString line = stream.readLine();
            if (line.startsWith('--') || line.trimmed().isEmpty()){
                continue;
            }
            q.exec(line);
        }
    }
}
