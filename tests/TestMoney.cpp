#include "TestMoney.h"

#include <TestMoney.h>
#include <Money.h>

#include <QtGlobal>
#include <QTest>
#include <QString>

#ifdef A_TEST_DEL
#include <QDebug>
#endif

void TestMoney::constructor_data(){
    QTest::addColumn<Money>("money");
    QTest::addColumn<Currency>("currencyResult");
    QTest::addColumn<qint64>("intResult");
    QTest::addColumn<qint32>("fractResult");

    QTest::newRow("empty")
            << Money()
            << Currency()
            << 0ll
            << 0;
    QTest::newRow("int amount/string currency code")
            << Money(777, "eur")
            << Currency("EUR")
            << 777ll
            << 0;
    QTest::newRow("negative float amount (-123.45f)/currency by class")
            << Money(-123.45f, Currency("USD"))
            << Currency("usd")
            << -123ll
            << 45;

    Money m = -123.01f;
    QTest::newRow("negative float amount (-123.01f)/none currency")
            << m
            << Currency()
            << -123ll
            << 01;
    QTest::newRow("double amount (666.223)/none currency")
            << Money(666.223)
            << Currency()
            << 666ll
            << 22;
    QTest::newRow("double amount (279.875)/none currency")
            << Money(279.875)
            << Currency()
            << 279ll
            << 87;
    QTest::newRow("double amount (1.23499)/currency with fractSize=3")
            << Money(1.23499, Currency("tst", 3))
            << Currency("tst")
            << 1ll
            << 234;
    QTest::newRow("by fractional unit/default currency")
            << Money(123499, Currency(), Money::FractionalUnit)
            << Currency()
            << 1234ll
            << 99;
    QTest::newRow("by fractional unit/currency with fractSize=5")
            << Money(1234997667, Currency("tst", 5), Money::FractionalUnit)
            << Currency("tst")
            << 12349ll
            << 97667;
}

void TestMoney::constructor(){
    QFETCH(Money, money);

    QTEST(money.currency(), "currencyResult");
    QTEST(money.integral(), "intResult");
    QTEST(money.fractional(), "fractResult");
}


void TestMoney::comparing(){
    QCOMPARE(Money(345, "rur"), Money(345.0f, "rur"));
    QCOMPARE(Money(39787, "rur", Money::FractionalUnit), Money(397.87));
    QCOMPARE(Money(3503, "rur", Money::FractionalUnit), Money(35.03));
    QCOMPARE(Money(664.345, "rur"), Money(664.345f));
    QCOMPARE(Money(823.378, "rur"), Money(823.371));
    QCOMPARE(Money(466.12, "rur"), Money(466.123));


    QVERIFY(Money(0) == (int)0);
    QVERIFY(Money(3) == 3.0f);
    QVERIFY(Money(123, "rur") != Money(123, "usd"));
    QVERIFY(Money(5544, "rur", Money::FractionalUnit) > Money(35.03));
    QVERIFY(Money(27593, "rur", Money::FractionalUnit) > Money(275.87f));
    QVERIFY(Money(7) > 4.3);
    QVERIFY(Money(7888.378, Currency()) > Money(823.371));
    QVERIFY(Money(767.999) < 1001);
    QVERIFY(Money(345678, Currency(), Money::FractionalUnit) <= 3456.78);
    QVERIFY(Money(345678, Currency(), Money::FractionalUnit) >= 3456.78);

}


void TestMoney::arithmetic(){
    Money m = Money(2.25, "usd") + Money(1, "rur");
    QVERIFY(!m.isValid());


    QCOMPARE(Money(2) + 34.22f, Money(36.22));

    QVERIFY((Money(0) - 100) == -100);
    QCOMPARE(Money(3) - 7, Money(-400, Currency(), Money::FractionalUnit));
    QCOMPARE(Money(173) - 12.346, Money(160.66));

    QCOMPARE((Money(7) / 3) * 3, Money(7));
    QCOMPARE((Money(11) / 7), Money(1.57));
    QCOMPARE(((Money(-17.88) / 5.0f / 3.0) * 5) * 3, Money(-17.88));
}


void TestMoney::toString_data(){
    QTest::addColumn<Money>("money");
    QTest::addColumn<QString>("format");
    QTest::addColumn<QString>("expected");

    QTest::newRow("null format")
            << Money(123.45)
            << QString()
            << QString("123.45 %1").arg(Currency::defaultCode);

    QTest::newRow("null format/irregular currency")
            << Money(-123.459, Currency("tst", 3))
            << QString()
            << QString("-123.459 %1").arg("TST");
}

void TestMoney::toString(){
    QFETCH(Money, money);
    QFETCH(QString, format);

    QTEST(money.toString(format), "expected");
}
