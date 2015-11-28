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

/*
class Currency{
    static QMap<QString, QSharedPointer<Currency> > m_currencyMap;

    // size of fractional unit of currency (e.g., number of cents in dollar for USD)
    qint16 m_fractSize;

    // code by ISO 4217 (USD, RUR, EUR, etc)
    const QString m_iso4217;



public:
    //! make instance by ISO 4217 code
    static const Currency& fromISO4217(const QString & code);

    //!
    QString code() const { return m_iso4217; }
    qint16 fractSize() const { return m_fractSize; }

    ~Currency(){
        qDebug() << "Currency " << m_iso4217 << " destroyed";
    }

private:
    Currency() : m_iso4217("default"), m_fractSize(0){qDebug() << "def constr";}
    Currency(const Currency &other) : m_fractSize(other.m_fractSize), m_iso4217(other.m_iso4217) {qDebug() << "copy constr";}
    Currency(const QString & code) : m_fractSize(100), m_iso4217(code) {qDebug() << "constr by code";}
    Currency& operator=(Currency &other) {qDebug() << "oper ="; this->m_fractSize = other.m_fractSize; return *this;}
};

namespace test{
    void testCurrency(){

        const Currency &c = Currency::fromISO4217("test");
        qDebug() << c.code();
        const Currency &c2 = Currency::fromISO4217("test");
        qDebug() << c2.code();

    }
}
*/


#endif // CURRENCY_H
