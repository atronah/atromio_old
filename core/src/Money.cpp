#include <Money.h>
#include <Currency.h>
#include <math.h>

#ifdef A_TEST_DEL
#include <QDebug>
#endif


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
    return lldiv(m_raw + divResult.rem, m_rawFactor).quot;
//    return divResult.quot
//            + ((abs(divResult.rem * 2) > m_rawFactor) ? 1 : 0)
//                * (m_raw > 0 ? 1 : -1);
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


