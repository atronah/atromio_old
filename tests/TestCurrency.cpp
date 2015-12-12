#include <TestCurrency.h>
#include <Currency.h>

#include <QObject>
#include <QTest>
#include <QString>

void TestCurrency::constructor_data(){
    QTest::addColumn<Currency>("currency");
    QTest::addColumn<QString>("codeResult");
    QTest::addColumn<QString>("nameResult");
    QTest::addColumn<qint16>("fractionSizeResult");
    
    QTest::newRow("none code") << Currency() 
                               << Currency::defaultCode
                               << Currency::defaultCode
                               << Currency::defaultFractionSize;
    QTest::newRow("null code") << Currency(QString()) 
                               << Currency::defaultCode
                               << Currency::defaultCode
                               << Currency::defaultFractionSize;
    QTest::newRow("empty code") << Currency("")
                                << Currency::defaultCode
                                << Currency::defaultCode
                                << Currency::defaultFractionSize;

    QTest::newRow("lower code/null name/negative size") << Currency("rur", QString(), -1)
                                                        << "RUR" 
                                                        << Currency::defaultCode
                                                        << Currency::defaultFractionSize;
    QTest::newRow("mixed code/normal name/normal fract size") << Currency("EuR", "test currency", 777)
                                                        << "EUR"
                                                        << "test currency" 
                                                        << (qint16)777;
    QTest::newRow("empty name/no fract size") << Currency("USD", "")
                                                << "USD" 
                                                << "USD" 
                                                << Currency::defaultFractionSize;
}

void TestCurrency::constructor(){
    QFETCH(Currency, currency);

    //QFETCH(QString, codeResult);
    //QFETCH(QString, nameResult);
    //QFETCH(qint16, fractionSizeResult);

    QTEST(currency.code(), "codeResult");
    QTEST(currency.name(), "nameResult");
    QTEST(currency.fractionSize(), "fractionSizeResult");
}


void TestCurrency::eq(){
  QVERIFY(Currency("rur", "test name", 5) == Currency("RUR", "", 2));
  QVERIFY(Currency("usd", "test", 2) != Currency("eur", "test", 2));
  QVERIFY(Currency() == Currency("RUR", "test", 8));
  QVERIFY(Currency() == Currency());
}
