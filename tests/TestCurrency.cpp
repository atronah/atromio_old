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
  File   : TestCurrency.cpp
  Created: 12.12.2015
  Reason : testing Currency class
  Product: atromio
  Author : atronah
*/

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
