/**************************************************************************
**  Copyright 2015 atronah.
**
**  This file is part of the  program.
**
**  atromis is free software: you can redistribute it and/or modify
**  it under the terms of the GNU Lesser General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**  atromis is distributed in the hope that it will be useful,
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
  File   : Money.h
  Created: 13.12.2015
  Reason : implementation money logic
  Product: atromio
  Author : atronah
*/

#ifndef MONEY_H
#define MONEY_H

#include <QtGlobal>
#include <Currency.h>

class Money
{
public:
    enum AmountType{
        MainUnit,
        FractionalUnit,
        RawData
    };

    Money()
        : m_currency(Currency())
        , m_raw(0)
        , m_valid(false) {}

    Money(qint64 amount,
          Currency currency = Currency(),
          AmountType amountType = MainUnit);

    Money(qint32 amount,
          Currency currency = Currency(),
          AmountType amountType = MainUnit)
        : Money(qint64(amount), currency, amountType) {}

    Money(double amount, Currency currency = Currency())
        : Money(qint64(amount * currency.fractionCount()), currency, FractionalUnit){}

    Money(float amount, Currency currency = Currency())
        : Money(qint64(amount * currency.fractionCount()), currency, FractionalUnit){}


    const Currency & currency() const { return m_currency; }
    double amount() const;
    qint64 integral() const;
    qint32 fractional() const;
    bool isValid() const {return m_valid; }
    bool isComparable(const Money &) const;
    QString toString(const QString & format = QString()) const;


    Money& operator =(const Money&);
    Money operator +(const Money&) const;
    Money operator -(const Money&) const;
    Money operator *(double) const;
    Money operator *(qint64) const;
    Money operator *(qint32 factor) const { return *this * (qint64)factor; }
    Money operator /(double) const;
    Money operator /(qint64) const;
    Money operator /(qint32 denom) const { return *this / (qint64)denom; }


protected:
    static qint16 m_rawFactor;

    qint64 raw() const {return m_raw; }

private:
    const Currency m_currency;
    qint64 m_raw;
    bool m_valid;

    qint64 normalized() const;

};


namespace MoneyError{
    class Error{
    public:
        Error(const QString &message)
            :m_message(message){}

    protected:
        const QString m_message;
    };

    class ComparingError : public Error{
    public:
        ComparingError(const QString & oper,
                       const Money &left,
                       const Money &right)
            : Error(QString("Error during comparing: %1 %2 %3").arg(left.toString())
                    .arg(oper)
                    .arg(right.toString())) {}
    };

//    class ArithmeticError : public Error{
//    public:
//        ArithmeticError(const QString & oper,
//                       const Money &left,
//                       const Money &right)
//            : Error(QString("Error during arithmetic: %1 %2 %3").arg(left.toString())
//                    .arg(oper)
//                    .arg(right.toString())) {}
//    };
}


bool operator ==(const Money &, const Money &);
bool operator !=(const Money &, const Money &);
bool operator <(const Money &, const Money &);
bool operator <=(const Money &, const Money &);
bool operator >(const Money &, const Money &);
bool operator >=(const Money &, const Money &);

//Money & operator +(const Money &, const Money &);
//bool operator -(const Money &, const Money &);
//bool operator *(const Money &, const Money &);
//bool operator /(const Money &, const Money &);




Q_DECLARE_METATYPE(Money)

#endif // MONEY_H
