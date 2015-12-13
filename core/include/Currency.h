/**************************************************************************
**  Copyright 2015 atronah.
**
**  This file is part of the  program.
**
**   is free software: you can redistribute it and/or modify
**  it under the terms of the GNU Lesser General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**   is distributed in the hope that it will be useful,
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
  Created: 9/7/2015
  Reason : implementation currency logic
  Product: atromio
  Author : atronah
*/

#ifndef CURRENCY_H
#define CURRENCY_H

#include <QtGlobal>
#include <QString>
#include <QMetaType>


class Currency{
public:
    static const QString &defaultCode;
    static const QString &defaultName;
    static const qint16 defaultFractionSize;

    Currency(const QString &code = QString(),
             const QString &name = QString(),
             qint16 fractionSize = -1);

    Currency(const char * code)
        : Currency(QString(code), QString()) {}

    Currency(const QString &code,
             qint16 fractionSize)
        : Currency(code, QString(), fractionSize) {}


    const QString & code() const { return m_code; }
    const QString & name() const { return m_name; }
    qint16 fractionSize() const { return m_fractionSize; }
    inline qint32 fractionCount() const {
        qint32 count = 1;
        for(auto i=m_fractionSize; i > 0; count *= 10,--i);
        return count; }

    virtual ~Currency(){}

private:
    // code by ISO 4217 (USD, RUR, EUR, etc)
    const QString m_code;
    // display name
    const QString m_name;
    // size of fractional unit of currency (e.g., number of cents in dollar for USD)
    qint16 m_fractionSize;

};

Q_DECLARE_METATYPE(Currency)

bool operator==(const Currency &, const Currency &);
bool operator!=(const Currency &, const Currency &);


#endif // CURRENCY_H
