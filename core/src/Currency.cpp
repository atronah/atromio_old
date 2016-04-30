/**************************************************************************
**  Copyright 2015 atronah.
**
**  This file is part of the  program.
**
**   is free software: you can redistribute it and/or modify
**  it under the terms of the GNU Lesser General Public License as published by
**  the Free Software Foundation, either version 3 of the License, or
**  (at your option) any later version.
**
**   is distributed in the hope that it will be useful,
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
  File   : Currency.cpp
  Created: 9/7/2015
  Reason :
  Product: atromio
  Author : atronah



  Purpose:

*/

#include <Currency.h>
#include <QString>

const QString &Currency::defaultCode = "RUR";
const qint16 Currency::defaultFractionSize = 2;


Currency::Currency(const QString &code,
                   const QString &name,
                   qint16 fractionSize)
    : m_code(code.isEmpty() ? Currency::defaultCode.toUpper()
                            : code.toUpper())
    , m_name(name.isEmpty() ? m_code
                            : name)
    , m_fractionSize(fractionSize < 0
                     || code.isEmpty() ? Currency::defaultFractionSize
                                       : fractionSize){
}


bool operator==(const Currency &left, const Currency &right) {
    return left.code() == right.code();
}

bool operator!=(const Currency &left, const Currency &right) {
    return !(left.code() == right.code());
}
