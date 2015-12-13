#include <Money.h>
#include <Currency.h>
#include <math.h>

//Money(double amount, Currency currency)
//    : m_currency(currency)
//    , m_integral((qint64)amount)
//    , m_fractional((qint64))
//{
//}

qint16 Money::m_rawFactor = 100;

Money::Money(qint64 amount, Currency currency, AmountType amountType)
    : m_currency(currency)
    , m_raw(amountType == RawData ? amount
                                  : m_rawFactor * (amountType == MainUnit ? amount
                                                                            * currency.fractionCount()
                                                                          : amount))
    , m_valid(true){
}

double Money::amount() const{
    return double(div(m_raw, m_rawFactor).quot) / m_currency.fractionCount();
}

qint64 Money::integral() const{
    return div(m_raw, m_rawFactor * m_currency.fractionCount()).quot;
}

qint32 Money::fractional() const{
    return div(abs(m_raw), m_rawFactor * m_currency.fractionCount()).rem;
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

Money Money::operator *(const Money &other) const{
    if (!isComparable(other)){
        return Money();
    }
    return Money(raw() * other.raw(), currency(), RawData);
}

Money Money::operator /(const Money &other) const{
    if (!isComparable(other)){
        return Money();
    }
    return Money(raw() / other.raw(), currency(), RawData);
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


