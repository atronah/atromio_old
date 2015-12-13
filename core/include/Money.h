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
