/**************************************************************************
**  Copyright 2015 atronah.
**
**  This file is part of the  program.
**
**  atromio is free software: you can redistribute it and/or modify
**  it under the terms of the GNU Lesser General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**  atromio is distributed in the hope that it will be useful,
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
  Created: 7/24/2015
  Reason : for currency types
  Product: atromio
  Author : atronah
*/

#ifndef MONEY_H
#define MONEY_H

#include <QtGlobal>
#include <QMap>
#include <QSharedPointer>
#include <QDebug>

/*
class Currency;


class Money
{
    //need for preservation of the accuracy in percent operations
    // e.g.: int(5 [cents] * 0.7) + int(5 * 0.3) = 4 cents, but int(500 * 0.7) + int(500 * 0.3) = 500
    // CANCELED: need only for calculating, not for store
    // static const auto m_precisionFactor = 100;


    //money represented by smallest part of currency (fractional currency) multiplied by precisionFactor
    //e.g.: if precisionFactor = 100, 100.32 RUB = 10032 * 100 = 1003200
    qint64 m_moneyData;
    Currency m_currency;

public:
    Money(qint64 main = 0, qint64 fract = 0);
    Money(const QString &money);
    Money(double money);

};
*/

#endif // MONEY_H
