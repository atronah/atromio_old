--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: ../changelog/dev-changelog.xml
--  Ran at: 03.05.16 0:19
--  Against: client@localhost@jdbc:mysql://localhost/atromio
--  Liquibase version: 3.4.2
--  *********************************************************************

--  Create Database Lock Table
CREATE TABLE atromio.DATABASECHANGELOGLOCK (ID INT NOT NULL, LOCKED BIT(1) NOT NULL, LOCKGRANTED datetime NULL, LOCKEDBY VARCHAR(255) NULL, CONSTRAINT PK_DATABASECHANGELOGLOCK PRIMARY KEY (ID));

--  Initialize Database Lock Table
DELETE FROM atromio.DATABASECHANGELOGLOCK;

INSERT INTO atromio.DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

--  Lock Database
UPDATE atromio.DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'A-UB-WIN7 (192.168.116.18)', LOCKGRANTED = '2016-05-03 00:19:02.964' WHERE ID = 1 AND LOCKED = 0;

--  Create Database Change Log Table
CREATE TABLE atromio.DATABASECHANGELOG (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED datetime NOT NULL, ORDEREXECUTED INT NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35) NULL, DESCRIPTION VARCHAR(255) NULL, COMMENTS VARCHAR(255) NULL, TAG VARCHAR(255) NULL, LIQUIBASE VARCHAR(20) NULL, CONTEXTS VARCHAR(255) NULL, LABELS VARCHAR(255) NULL);

--  Changeset ../changelog/init/create-refbooks.xml::create_refbooks::atronah
CREATE TABLE atromio.unit (id INT AUTO_INCREMENT NOT NULL, designation VARCHAR(8) NOT NULL COMMENT 'reduced name of unit', name VARCHAR(64) NOT NULL COMMENT 'name', description VARCHAR(255) NOT NULL COMMENT 'description of unit', CONSTRAINT PK_UNIT PRIMARY KEY (id)) COMMENT='units for counting (kg, cm, pices and etc)';

ALTER TABLE atromio.unit COMMENT = 'units for counting (kg, cm, pices and etc)';

CREATE TABLE atromio.currency (id INT AUTO_INCREMENT NOT NULL, code VARCHAR(3) NOT NULL COMMENT 'code by ISO 4217', idx SMALLINT DEFAULT 0 NOT NULL COMMENT 'sort index for currencies', name VARCHAR(64) NOT NULL COMMENT 'name of currency', symbol VARCHAR(1) NOT NULL COMMENT 'symbol of currency', fraction_size SMALLINT DEFAULT 2 NOT NULL COMMENT 'size of fraction part of currency', CONSTRAINT PK_CURRENCY PRIMARY KEY (id), UNIQUE (code), UNIQUE (symbol)) COMMENT='money representation';

ALTER TABLE atromio.currency COMMENT = 'money representation';

CREATE TABLE atromio.category (id INT AUTO_INCREMENT NOT NULL, type SMALLINT DEFAULT 0 NOT NULL COMMENT '0-goods, 1-service', name VARCHAR(64) NOT NULL COMMENT 'name of category', parent_id INT NULL COMMENT 'parent category {category}', CONSTRAINT PK_CATEGORY PRIMARY KEY (id), CONSTRAINT fk_category_parent_category FOREIGN KEY (parent_id) REFERENCES category(id)) COMMENT='category of goods and services';

ALTER TABLE atromio.category COMMENT = 'category of goods and services';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_refbooks', 'atronah', '../changelog/init/create-refbooks.xml', NOW(), 1, '7:6351918a834a05daf83dde96387a8974', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-person.xml::create_person::atronah
CREATE TABLE atromio.person (id INT AUTO_INCREMENT NOT NULL, short_name VARCHAR(32) NOT NULL COMMENT 'short person''s name', full_name VARCHAR(255) DEFAULT '' NOT NULL COMMENT 'full person''s name', type SMALLINT DEFAULT 0 NOT NULL COMMENT 'person''s type (0 - natural person, 1 - legal person', CONSTRAINT PK_PERSON PRIMARY KEY (id)) COMMENT='info about some persons';

ALTER TABLE atromio.person COMMENT = 'info about some persons';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_person', 'atronah', '../changelog/init/create-person.xml', NOW(), 2, '7:55332778ad21ace5694bb4cda4ccaad2', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-user.xml::create_user::atronah
CREATE TABLE atromio.user (id INT AUTO_INCREMENT NOT NULL, login VARCHAR(32) NOT NULL COMMENT 'authentication user''s name', password VARCHAR(255) NOT NULL COMMENT 'hash of user''s password', person_id INT NOT NULL COMMENT 'referred person', CONSTRAINT PK_USER PRIMARY KEY (id), CONSTRAINT fk_user_person FOREIGN KEY (person_id) REFERENCES person(id), UNIQUE (login)) COMMENT='user of system and database';

ALTER TABLE atromio.user COMMENT = 'user of system and database';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_user', 'atronah', '../changelog/init/create-user.xml', NOW(), 3, '7:31e27d1ecffbcc7c1ccb5130a9481a7a', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-product.xml::create_product::atronah
CREATE TABLE atromio.product (id INT AUTO_INCREMENT NOT NULL, code VARCHAR(128) DEFAULT '' NOT NULL COMMENT 'code of product (e.g. barcode or ISBN)', name VARCHAR(64) NOT NULL COMMENT 'name of product', maker_id INT NULL COMMENT 'product maker {person}', category_id INT NULL COMMENT 'category of product {category}', CONSTRAINT PK_PRODUCT PRIMARY KEY (id), CONSTRAINT fk_Product_Maker_Person FOREIGN KEY (maker_id) REFERENCES Person(id), CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(id)) COMMENT='goods and services, purchased or planned or etc';

ALTER TABLE atromio.product COMMENT = 'goods and services, purchased or planned or etc';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_product', 'atronah', '../changelog/init/create-product.xml', NOW(), 4, '7:d4dcc8feefcfc5fa758ac4e8b403b31a', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-invoice.xml::create_invoice::atronah
CREATE TABLE atromio.invoice (id INT AUTO_INCREMENT NOT NULL, created datetime NOT NULL COMMENT 'date and time, when invoice has been created', completed datetime NULL COMMENT 'date and time, when invoice has been payed and/or completed', expired datetime NULL COMMENT 'date and time, when invoice will be expired', type SMALLINT DEFAULT 0 NOT NULL COMMENT '0-goods,1-cashback,2-correction,3-transfer,4-exchange,5-debt,6-gift,7-planning,8-monitoring', name VARCHAR(64) NOT NULL COMMENT 'title or number of invoice', amount BIGINT NOT NULL COMMENT 'amount of money operation (without discounts and taxes)', currency_id INT NULL COMMENT 'invoice amount currency (null=rubles) {currency}', discount BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of discount in invoice currency', tax BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of tax in invoice currency', note TEXT DEFAULT '' NOT NULL COMMENT 'additional info for invoice', ref_invoice_id INT NULL COMMENT 'referenced invoice {invoice}', ref_type SMALLINT DEFAULT 0 NOT NULL COMMENT '0-refinvoice is parent, 1-is sibling', supplier_id INT NULL COMMENT 'Supplier/provider/contractor/payee {person}', customer_id INT NULL COMMENT 'customer/buyer/payer/consumer/asquirer/purchaser {person}', CONSTRAINT PK_INVOICE PRIMARY KEY (id), CONSTRAINT fk_invoice_Supplier_person FOREIGN KEY (supplier_id) REFERENCES person(id), CONSTRAINT fk_invoice_currency FOREIGN KEY (currency_id) REFERENCES currency(id), CONSTRAINT fk_invoice_invoice FOREIGN KEY (ref_invoice_id) REFERENCES invoice(id), CONSTRAINT fk_invoice_customer_person FOREIGN KEY (customer_id) REFERENCES person(id)) COMMENT='invoice with details of money earn/spend';

ALTER TABLE atromio.invoice COMMENT = 'invoice with details of money earn/spend';

CREATE TABLE atromio.purchase (id INT AUTO_INCREMENT NOT NULL, invoice_id INT NOT NULL COMMENT 'invoice {invoice}', quantity DECIMAL(15, 5) DEFAULT 1.0 NOT NULL COMMENT 'quantity of product in specified unit', unit_id INT NULL COMMENT 'unit for quantity (null=pieces) {unit}', price BIGINT NOT NULL COMMENT 'price of purchase in currency of invoice', discount BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of discount in invoice currency', tax BIGINT DEFAULT 0 NOT NULL COMMENT 'amount of tax in invoice currency', is_aproximate SMALLINT DEFAULT 0 NOT NULL COMMENT '0-exact price,1-aproximate price', CONSTRAINT PK_PURCHASE PRIMARY KEY (id), CONSTRAINT fk_purchase_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(id), CONSTRAINT fk_purchase_unit FOREIGN KEY (unit_id) REFERENCES unit(id)) COMMENT='purchased invoice item';

ALTER TABLE atromio.purchase COMMENT = 'purchased invoice item';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_invoice', 'atronah', '../changelog/init/create-invoice.xml', NOW(), 5, '7:2226c228a41c626c0ecf5ab00953e847', 'createTable (x2)', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-account.xml::create_account::atronah
CREATE TABLE atromio.account_type (id INT AUTO_INCREMENT NOT NULL, name VARCHAR(64) NOT NULL COMMENT 'name of account type', is_cash SMALLINT DEFAULT 0 NOT NULL COMMENT 'a sign of cash accounts', CONSTRAINT PK_ACCOUNT_TYPE PRIMARY KEY (id)) COMMENT='money storage type';

ALTER TABLE atromio.account_type COMMENT = 'money storage type';

CREATE TABLE atromio.account (id INT AUTO_INCREMENT NOT NULL, created datetime DEFAULT NOW() NOT NULL COMMENT 'date and time, when account has been created', opened datetime NULL COMMENT 'date and time, when account has been opened', closed datetime NULL COMMENT 'date and time, when account has been closed', name VARCHAR(64) NOT NULL COMMENT 'name of account', description VARCHAR(255) DEFAULT '' NOT NULL COMMENT 'description of account', type_id INT NOT NULL COMMENT 'account type {account_type}', owner_id INT NOT NULL COMMENT 'account owner {person}', CONSTRAINT PK_ACCOUNT PRIMARY KEY (id), CONSTRAINT fk_account_type FOREIGN KEY (type_id) REFERENCES account_type(id), CONSTRAINT fk_account_owner_person FOREIGN KEY (owner_id) REFERENCES person(id)) COMMENT='money storage';

ALTER TABLE atromio.account COMMENT = 'money storage';

CREATE TABLE atromio.balance (id INT AUTO_INCREMENT NOT NULL, account_id INT NOT NULL COMMENT 'account, which balance stored {account}', checked datetime NOT NULL COMMENT 'date and time, when account balance has been checked', amount BIGINT NOT NULL COMMENT 'amount money on account on checked date with specified currency', currency_id INT NULL COMMENT 'currency of stamp (null=rubles) {currency}', CONSTRAINT PK_BALANCE PRIMARY KEY (id), CONSTRAINT fk_balance_account FOREIGN KEY (account_id) REFERENCES account(id), CONSTRAINT fk_balance_currency FOREIGN KEY (currency_id) REFERENCES currency(id)) COMMENT='stamp of account balance on date';

ALTER TABLE atromio.balance COMMENT = 'stamp of account balance on date';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_account', 'atronah', '../changelog/init/create-account.xml', NOW(), 6, '7:4b47f1103d29004edf86bed5babeb0f2', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/init/create-operation.xml::create_operation::atronah
CREATE TABLE atromio.operation (id INT AUTO_INCREMENT NOT NULL, account_id INT NOT NULL COMMENT 'money own account {account}', created datetime DEFAULT NOW() NOT NULL COMMENT 'date and time, when operation has been created', performed datetime NULL COMMENT 'date and time, when operation has been performed', canceled datetime NULL COMMENT 'date and time, when operation has been canceled', amount BIGINT NOT NULL COMMENT 'amount money in operation', currency_id INT NOT NULL COMMENT 'currency of operation {currency}', direction SMALLINT DEFAULT 0 NOT NULL COMMENT 'direction of operation (0 - spending/outcome, 1 - earn/income', performer_id INT NOT NULL COMMENT 'person, who performed operation {person}', invoice_id INT NULL COMMENT 'operation invoice {invoice}', CONSTRAINT PK_OPERATION PRIMARY KEY (id), CONSTRAINT fk_operation_perform_person_id FOREIGN KEY (performer_id) REFERENCES person(id), CONSTRAINT fk_operation_account_id FOREIGN KEY (account_id) REFERENCES account(id), CONSTRAINT fk_operation_currency_id FOREIGN KEY (currency_id) REFERENCES currency(id), CONSTRAINT fk_operation_invoice_id FOREIGN KEY (invoice_id) REFERENCES invoice(id)) COMMENT='money operations';

ALTER TABLE atromio.operation COMMENT = 'money operations';

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_operation', 'atronah', '../changelog/init/create-operation.xml', NOW(), 7, '7:89f20e8b4ba79151933d6af7b34b74c8', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::RUR::atronah
INSERT INTO atromio.currency (code, idx, name, symbol, fractionSize) VALUES ('RUR', '0', 'Российский рубль', '₽', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('RUR', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 8, '7:55528a3008b96e5f9b0fb5585853d9ab', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::USD::atronah
INSERT INTO atromio.currency (code, idx, name, symbol, fraction_size) VALUES ('USD', '1', 'Доллар США', '$', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('USD', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 9, '7:7ef288a4b56d22f4ca28e3c9d0beebad', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::EUR::atronah
INSERT INTO atromio.currency (code, idx, name, symbol, fraction_size) VALUES ('EUR', '2', 'Евро', '€', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('EUR', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 10, '7:c7765a96ba88e0bc4670305ce6e80a89', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Changeset ../changelog/data/insert-primary-currency.xml::TRY::atronah
INSERT INTO atromio.currency (code, idx, name, symbol, fraction_size) VALUES ('TRY', '3', 'Турецкая лира', '₺', '2');

INSERT INTO atromio.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('TRY', 'atronah', '../changelog/data/insert-primary-currency.xml', NOW(), 11, '7:c6f06eafae6ee60f1084c295d36f1e91', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

--  Release Database Lock
UPDATE atromio.DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

