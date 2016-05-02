--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: ../changelog/dev-changelog.xml
--  Ran at: 03.05.16 0:03
--  Against: client@localhost@jdbc:mysql://localhost/atromio
--  Liquibase version: 3.4.2
--  *********************************************************************

--  Create Database Lock Table
CREATE TABLE atromio.DATABASECHANGELOGLOCK (ID INT NOT NULL, LOCKED BIT(1) NOT NULL, LOCKGRANTED datetime NULL, LOCKEDBY VARCHAR(255) NULL, CONSTRAINT PK_DATABASECHANGELOGLOCK PRIMARY KEY (ID));

--  Initialize Database Lock Table
DELETE FROM atromio.DATABASECHANGELOGLOCK;

INSERT INTO atromio.DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

--  Lock Database
UPDATE atromio.DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'A-UB-WIN7 (192.168.116.18)', LOCKGRANTED = '2016-05-03 00:03:59.929' WHERE ID = 1 AND LOCKED = 0;

--  Create Database Change Log Table
CREATE TABLE atromio.DATABASECHANGELOG (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED datetime NOT NULL, ORDEREXECUTED INT NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35) NULL, DESCRIPTION VARCHAR(255) NULL, COMMENTS VARCHAR(255) NULL, TAG VARCHAR(255) NULL, LIQUIBASE VARCHAR(20) NULL, CONTEXTS VARCHAR(255) NULL, LABELS VARCHAR(255) NULL);

--  Changeset ../changelog/init/create-Refbooks.xml::createRefbooks::atronah
CREATE TABLE atromio.Unit (id INT AUTO_INCREMENT NOT NULL, designation VARCHAR(8) NOT NULL COMMENT 'reduced name of unit', name VARCHAR(64) NOT NULL COMMENT 'name', description VARCHAR(255) NOT NULL COMMENT 'description of unit', CONSTRAINT PK_UNIT PRIMARY KEY (id)) COMMENT='units for counting (kg, cm, pices and etc)';

ALTER TABLE atromio.Unit COMMENT = 'units for counting (kg, cm, pices and etc)';

CREATE TABLE atromio.Currency (id INT AUTO_INCREMENT NOT NULL, code VARCHAR(3) NOT NULL COMMENT 'code by ISO 4217', idx SMALLINT DEFAULT 0 NOT NULL COMMENT 'sort index for currencies', name VARCHAR(64) NOT NULL COMMENT 'name of currency', symbol VARCHAR(1) NOT NULL COMMENT 'symbol of currency', fractionSize SMALLINT DEFAULT 2 NOT NULL COMMENT 'size of fraction part of currency', CONSTRAINT PK_CURRENCY PRIMARY KEY (id), UNIQUE (code), UNIQUE (symbol)) COMMENT='money representation';

ALTER TABLE atromio.Currency COMMENT = 'money representation';

CREATE TABLE atromio.Category (id INT AUTO_INCREMENT NOT NULL, type SMALLINT DEFAULT 0 NOT NULL COMMENT '0-goods, 1-service', name VARCHAR(64) NOT NULL COMMENT 'name of category', parent_id INT NULL COMMENT 'parent category {Category}', CONSTRAINT PK_CATEGORY PRIMARY KEY (id), CONSTRAINT fk_Category_Parent_Category FOREIGN KEY (parent_id) REFERENCES Category(id)) COMMENT='category of goods and services';

ALTER TABLE atromio.Category COMMENT = 'category of goods and services';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createRefbooks', 'atronah', '../changelog/init/create-Refbooks.xml', NOW(), 1, '7:f5f02eb9ce5e9f0f9b609226fd557e17', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-Person.xml::createPerson::atronah
CREATE TABLE atromio.Person (id INT AUTO_INCREMENT NOT NULL, shortName VARCHAR(32) NOT NULL COMMENT 'short person''s name', fullName VARCHAR(255) DEFAULT '' NOT NULL COMMENT 'full person''s name', type SMALLINT DEFAULT 0 NOT NULL COMMENT 'person''s type (0 - natural person, 1 - legal person', CONSTRAINT PK_PERSON PRIMARY KEY (id)) COMMENT='info about some persons';

ALTER TABLE atromio.Person COMMENT = 'info about some persons';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createPerson', 'atronah', '../changelog/init/create-Person.xml', NOW(), 2, '7:f306c70399888d21da712e1ddea47483', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-User.xml::createUser::atronah
CREATE TABLE atromio.User (id INT AUTO_INCREMENT NOT NULL, login VARCHAR(32) NOT NULL COMMENT 'authentication user''s name', password VARCHAR(255) NOT NULL COMMENT 'hash of user''s password', person_id INT NOT NULL COMMENT 'referred person', CONSTRAINT PK_USER PRIMARY KEY (id), CONSTRAINT fk_User_Person FOREIGN KEY (person_id) REFERENCES Person(id), UNIQUE (login)) COMMENT='user of system and database';

ALTER TABLE atromio.User COMMENT = 'user of system and database';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createUser', 'atronah', '../changelog/init/create-User.xml', NOW(), 3, '7:79f72b1e1ebcb384f79d101d9bc32a35', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-Product.xml::createProduct::atronah
CREATE TABLE atromio.Product (id INT AUTO_INCREMENT NOT NULL, code VARCHAR(128) DEFAULT '' NOT NULL COMMENT 'code of product (e.g. barcode or ISBN)', name VARCHAR(64) NOT NULL COMMENT 'name of product', maker_id INT NULL COMMENT 'product maker {Person}', category_id INT NULL COMMENT 'category of product {Category}', CONSTRAINT PK_PRODUCT PRIMARY KEY (id), CONSTRAINT fk_Product_Maker_Person FOREIGN KEY (maker_id) REFERENCES Person(id), CONSTRAINT fk_Product_Category FOREIGN KEY (category_id) REFERENCES Category(id)) COMMENT='goods and services, purchased or planned or etc';

ALTER TABLE atromio.Product COMMENT = 'goods and services, purchased or planned or etc';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createProduct', 'atronah', '../changelog/init/create-Product.xml', NOW(), 4, '7:98426c73089cfe26f1f70a3ed0790cae', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-Invoice.xml::createInvoice::atronah
CREATE TABLE atromio.Invoice (id INT AUTO_INCREMENT NOT NULL, created datetime NOT NULL COMMENT 'date and time, when invoice has been created', completed datetime NULL COMMENT 'date and time, when invoice has been payed and/or completed', expired datetime NULL COMMENT 'date and time, when invoice will be expired', type SMALLINT DEFAULT 0 NOT NULL COMMENT '0-goods,1-cashback,2-correction,3-transfer,4-exchange,5-debt,6-gift,7-planning,8-monitoring', name VARCHAR(64) NOT NULL COMMENT 'title or number of invoice', amount BIGINT NOT NULL COMMENT 'amount of money operation (without discounts and taxes)', currency_id INT NULL COMMENT 'invoice amount currency (null=rubles) {Currency}', discount BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of discount in invoice currency', tax BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of tax in invoice currency', note TEXT DEFAULT '' NOT NULL COMMENT 'additional info for invoice', refInvoice_id INT NULL COMMENT 'referenced invoice {Invoice}', refType SMALLINT DEFAULT 0 NOT NULL COMMENT '0-refInvoice is parent, 1-is sibling', supplier_id INT NULL COMMENT 'Supplier/provider/contractor/payee {Person}', customer_id INT NULL COMMENT 'Customer/buyer/payer/consumer/asquirer/purchaser {Person}', CONSTRAINT PK_INVOICE PRIMARY KEY (id), CONSTRAINT fk_Invoice_Supplier_Person FOREIGN KEY (supplier_id) REFERENCES Person(id), CONSTRAINT fk_Invoice_Currency FOREIGN KEY (currency_id) REFERENCES Currency(id), CONSTRAINT fk_Invoice_Invoice FOREIGN KEY (refInvoice_id) REFERENCES Invoice(id), CONSTRAINT fk_Invoice_Customer_Person FOREIGN KEY (customer_id) REFERENCES Person(id)) COMMENT='invoice with details of money earn/spend';

ALTER TABLE atromio.Invoice COMMENT = 'invoice with details of money earn/spend';

CREATE TABLE atromio.Purchase (id INT AUTO_INCREMENT NOT NULL, invoice_id INT NOT NULL COMMENT 'invoice {Invoice}', quantity DECIMAL(15, 5) DEFAULT 1.0 NOT NULL COMMENT 'quantity of product in specified unit', unit_id INT NULL COMMENT 'unit for quantity (null=pieces) {Unit}', price BIGINT NOT NULL COMMENT 'price of purchase in currency of invoice', discount BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of discount in invoice currency', tax BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of tax in invoice currency', isAproximate SMALLINT DEFAULT 0 NOT NULL COMMENT '0-exact price,1-aproximate price', CONSTRAINT PK_PURCHASE PRIMARY KEY (id), CONSTRAINT fk_Purchase_Invoice FOREIGN KEY (invoice_id) REFERENCES Invoice(id), CONSTRAINT fk_Purchase_Unit FOREIGN KEY (unit_id) REFERENCES Unit(id)) COMMENT='purchased invoice item';

ALTER TABLE atromio.Purchase COMMENT = 'purchased invoice item';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createInvoice', 'atronah', '../changelog/init/create-Invoice.xml', NOW(), 5, '7:4a4b7b47071d1391ef471cfe93a5d2d8', 'createTable (x2)', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-Account.xml::createAccount::atronah
CREATE TABLE atromio.AccountType (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(64) NOT NULL COMMENT 'name of account type', isCash SMALLINT DEFAULT 0 NOT NULL COMMENT 'a sign of cash accounts', CONSTRAINT PK_ACCOUNTTYPE PRIMARY KEY (id)) COMMENT='money storage type';

ALTER TABLE atromio.AccountType COMMENT = 'money storage type';

CREATE TABLE atromio.Account (id INT AUTO_INCREMENT NOT NULL, created datetime DEFAULT 'current_timestamp' NOT NULL COMMENT 'date and time, when account has been created', opened datetime NULL COMMENT 'date and time, when account has been opened', closed datetime NULL COMMENT 'date and time, when account has been closed', name VARCHAR(64) NOT NULL COMMENT 'name of account', description VARCHAR(255) DEFAULT '' NOT NULL COMMENT 'description of account', type_id INT NOT NULL COMMENT 'account type {AccountType}', owner_id INT NOT NULL COMMENT 'account owner {Person}', CONSTRAINT PK_ACCOUNT PRIMARY KEY (id), CONSTRAINT fk_Account_Type FOREIGN KEY (type_id) REFERENCES AccountType(id), CONSTRAINT fk_Account_Owner_Person FOREIGN KEY (owner_id) REFERENCES Person(id)) COMMENT='money storage';

ALTER TABLE atromio.Account COMMENT = 'money storage';

CREATE TABLE atromio.Balance (id INT AUTO_INCREMENT NOT NULL, account_id INT NOT NULL COMMENT 'account, which balance stored {Account}', checked datetime NOT NULL COMMENT 'date and time, when account balance has been checked', amount BIGINT NOT NULL COMMENT 'amount money on account on checked date with specified currency', currency_id INT NULL COMMENT 'currency of stamp (null=rubles) {Currency}', CONSTRAINT PK_BALANCE PRIMARY KEY (id), CONSTRAINT fk_Balance_Account FOREIGN KEY (account_id) REFERENCES Account(id), CONSTRAINT fk_Balance_Currency FOREIGN KEY (currency_id) REFERENCES Currency(id)) COMMENT='stamp of account balance on date';

ALTER TABLE atromio.Balance COMMENT = 'stamp of account balance on date';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createAccount', 'atronah', '../changelog/init/create-Account.xml', NOW(), 6, '7:82a23e26daa4b99d31884b6f9b4b52a3', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-Operation.xml::createOperation::atronah
CREATE TABLE atromio.Operation (id INT AUTO_INCREMENT NOT NULL, account_id INT NOT NULL COMMENT 'money own account {Account}', created datetime DEFAULT 'current_timestamp' NOT NULL COMMENT 'date and time, when operation has been created', performed datetime NULL COMMENT 'date and time, when operation has been performed', canceled datetime NULL COMMENT 'date and time, when operation has been canceled', amount BIGINT NOT NULL COMMENT 'amount money in operation', currency_id INT NOT NULL COMMENT 'currency of operation {Currency}', direction SMALLINT DEFAULT 0 NOT NULL COMMENT 'direction of operation (0 - spending/outcome, 1 - earn/income', performer_id INT NOT NULL COMMENT 'person, who performed operation {Person}', invoice_id INT NULL COMMENT 'operation invoice {Invoice}', CONSTRAINT PK_OPERATION PRIMARY KEY (id), CONSTRAINT fk_Operation_Perform_Person_id FOREIGN KEY (performer_id) REFERENCES Person(id), CONSTRAINT fk_Operation_Account_id FOREIGN KEY (account_id) REFERENCES Account(id), CONSTRAINT fk_Operation_Currency_id FOREIGN KEY (currency_id) REFERENCES Currency(id), CONSTRAINT fk_Operation_Invoice_id FOREIGN KEY (invoice_id) REFERENCES Invoice(id)) COMMENT='money operations';

ALTER TABLE atromio.Operation COMMENT = 'money operations';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('createOperation', 'atronah', '../changelog/init/create-Operation.xml', NOW(), 7, '7:996bcb105e4de157c2b800d8997c8253', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::RUR::atronah
INSERT INTO atromio.Currency (code, idx, name, symbol, fractionSize) VALUES ('RUR', '0', 'Российский рубль', '₽', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('RUR', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 8, '7:f89340b549b57a2d05d3fd785af08429', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::USD::atronah
INSERT INTO atromio.Currency (code, idx, name, symbol, fractionSize) VALUES ('USD', '1', 'Доллар США', '$', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('USD', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 9, '7:e2a809de169513a3716a9ae42210d1ff', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::EUR::atronah
INSERT INTO atromio.Currency (code, idx, name, symbol, fractionSize) VALUES ('EUR', '2', 'Евро', '€', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('EUR', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 10, '7:6e3572ed415cf8ca20ab84c21658cb2f', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::TRY::atronah
INSERT INTO atromio.Currency (code, idx, name, symbol, fractionSize) VALUES ('TRY', '3', 'Турецкая лира', '₺', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('TRY', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 11, '7:2655b732922411fa9279786b73988680', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Release Database Lock
UPDATE atromio.DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

