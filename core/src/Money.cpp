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
  File   : Money.cpp
  Created: 13.12.2015
  Reason : implementation money logic
  Product: atromio
  Author : atronah
*/

#include <Money.h>
#include <Currency.h>
#include <math.h>

qint16 Money::m_rawFactor = 100;

Money::Money(qint64 amount, Currency currency, AmountType amountType)
    : m_currency(currency)
    , m_raw((amountType == RawData) ? amount
                                    : (m_rawFactor * ((amountType == MainUnit)
                                                     ? (amount * currency.fractionCount())
                                                     : amount)))
    , m_valid(true){
}


qint64 Money::normalized() const{
    lldiv_t divResult = lldiv(m_raw, m_rawFactor);
    // increase amount by 1 if precision part >= 50 (for rawFactor=2)
    // e.g. 1234551 -> 123.46 because precision part is "51"
    // but 9873201 -> 987.32 because precision part is "01" < 50
    return lldiv(m_raw + divResult.rem, m_rawFactor).quot;
}

double Money::amount() const{
    return double(normalized()) / m_currency.fractionCount() ;
}

qint64 Money::integral() const{
    return div(normalized(), m_currency.fractionCount()).quot;
}

qint32 Money::fractional() const{
    return div(abs(normalized()), m_currency.fractionCount()).rem;
}

bool Money::isComparable(const Money &other) const{
    return this->isValid()
            && other.isValid()
            && this->currency() == other.currency();
}

QString Money::toString(const QString &format) const{
    return QString("%1 %2").arg(amount()).arg(currency().code());
}


Money& Money::operator=(const Money &other){
    m_valid = other.currency() == m_currency;
    if (isValid()){
        m_raw = other.raw();
    }
    return *this;
}

Money Money::operator +(const Money &other) const{
    if (!isComparable(other)){
        return Money();
    }
    return Money(raw() + other.raw(), currency(), RawData);
}

Money Money::operator -(const Money &other) const{
    return *this + Money(-other.raw(), currency(), RawData);
}

Money Money::operator *(double factor) const{
    return Money(qint64(raw() * factor), currency(), RawData);
}

Money Money::operator *(qint64 factor) const{
    return Money(qint64(raw() * factor), currency(), RawData);
}

Money Money::operator /(double denom) const{
    return Money(qint64(raw() / denom), currency(), RawData);
}


Money Money::operator /(qint64 denom) const{
    lldiv_t divResult = lldiv(raw(), denom);
    if (divResult.rem == 0){
        return Money(divResult.quot, currency(), RawData);
    }
    return Money(raw() / denom, currency(), RawData);
}

bool operator ==(const Money &left, const Money &right){
    return left.isComparable(right)
            && left.integral() == right.integral()
            && left.fractional() == right.fractional();
}

bool operator !=(const Money &left, const Money &right){
    return !(left == right);
}

bool operator <(const Money &left, const Money &right){
    if (!left.isComparable(right)){
        throw MoneyError::ComparingError("<", left, right);
    }

    return (left.integral() == right.integral())
            ? (left.fractional() < right.fractional())
            : (left.integral() < right.integral());
}

bool operator <=(const Money &left, const Money &right){
    if (!left.isComparable(right)){
        throw MoneyError::ComparingError("<=", left, right);
    }
    return left < right || left == right;
}

bool operator >(const Money &left, const Money &right){
    if (!left.isComparable(right)){
        throw MoneyError::ComparingError(">", left, right);
    }
    return !(left <= right);
}

bool operator >=(const Money &left, const Money &right){
    if (!left.isComparable(right)){
        throw MoneyError::ComparingError(">=", left, right);
    }
    return !(left < right);
}


