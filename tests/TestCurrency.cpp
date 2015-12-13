#include <TestCurrency.h>
#include <Currency.h>


#include <QTest>
#include <QString>
#include <QtGlobal>

void TestCurrency::constructor_data(){
    QTest::addColumn<Currency>("currency");
    QTest::addColumn<QString>("codeResult");
    QTest::addColumn<QString>("nameResult");
    QTest::addColumn<qint16>("fractionSizeResult");
    
    QTest::newRow("none code")
            << Currency()
            << Currency::defaultCode
            << Currency::defaultCode
            << Currency::defaultFractionSize;
    QTest::newRow("null code")
            << Currency(QString())
            << Currency::defaultCode
            << Currency::defaultCode
            << Currency::defaultFractionSize;
    QTest::newRow("empty code")
            << Currency("")
            << Currency::defaultCode
            << Currency::defaultCode
            << Currency::defaultFractionSize;
    QTest::newRow("empty code/not default fractional size")
            << Currency("", 4)
            << Currency::defaultCode
            << Currency::defaultCode
            << Currency::defaultFractionSize;

    Currency c = "tst";
    QTest::newRow("by char array")
            << c
            << "TST"
            << "TST"
            << Currency::defaultFractionSize;
    QTest::newRow("lower code/null name/negative size")
            << Currency("rur", QString(), -8)
            << "RUR"
            << Currency::defaultCode
            << Currency::defaultFractionSize;
    QTest::newRow("empty name/no fract size")
            << Currency("USD", "")
            << "USD"
            << "USD"
            << Currency::defaultFractionSize;
    QTest::newRow("mixed code/normal name/normal fract size")
            << Currency("EuR", "test currency", 777)
            << "EUR"
            << "test currency"
            << (qint16)777;
}

void TestCurrency::constructor(){
    QFETCH(Currency, currency);

    QTEST(currency.code(), "codeResult");
    QTEST(currency.name(), "nameResult");
    QTEST(currency.fractionSize(), "fractionSizeResult");
}


void TestCurrency::eq(){
    QVERIFY(Currency("usd", "test", 2) != Currency("eur", "test", 2));
    QCOMPARE(Currency("rur", "test name", 5), Currency("RUR", "", 2));

    QCOMPARE(Currency(), Currency("RUR", "test", 8));
    QCOMPARE(Currency(), Currency());
}


void TestCurrency::others(){
    Currency c = "usd";
    QCOMPARE(c, Currency("usd"));
}
