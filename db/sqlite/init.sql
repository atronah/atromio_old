-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: ../changelog/dev-changelog.xml
-- Ran at: 03.05.16 0:31
-- Against: null@jdbc:sqlite:data.db
-- Liquibase version: 3.4.2
-- *********************************************************************

-- Create Database Lock Table
CREATE TABLE DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED BOOLEAN NOT NULL, LOCKGRANTED TEXT, LOCKEDBY VARCHAR(255), CONSTRAINT PK_DATABASECHANGELOGLOCK PRIMARY KEY (ID));

-- Initialize Database Lock Table
DELETE FROM DATABASECHANGELOGLOCK;

INSERT INTO DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

-- Lock Database
UPDATE DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'A-UB-WIN7 (192.168.116.18)', LOCKGRANTED = '2016-05-03 00:31:00.332' WHERE ID = 1 AND LOCKED = 0;

-- Create Database Change Log Table
CREATE TABLE DATABASECHANGELOG (ID VARCHAR(255) NOT NULL, AUTHOR VARCHAR(255) NOT NULL, FILENAME VARCHAR(255) NOT NULL, DATEEXECUTED TEXT NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR(10) NOT NULL, MD5SUM VARCHAR(35), DESCRIPTION VARCHAR(255), COMMENTS VARCHAR(255), TAG VARCHAR(255), LIQUIBASE VARCHAR(20), CONTEXTS VARCHAR(255), LABELS VARCHAR(255));

-- Changeset ../changelog/init/create-refbooks.xml::create_refbooks::atronah
CREATE TABLE unit (id INTEGER CONSTRAINT PK_UNIT PRIMARY KEY AUTOINCREMENT NOT NULL, designation VARCHAR(8) NOT NULL, name VARCHAR(64) NOT NULL, description VARCHAR(255) NOT NULL);

CREATE TABLE currency (id INTEGER CONSTRAINT PK_CURRENCY PRIMARY KEY AUTOINCREMENT NOT NULL, code VARCHAR(3) NOT NULL, idx SMALLINT DEFAULT 0 NOT NULL, name VARCHAR(64) NOT NULL, symbol VARCHAR(1) NOT NULL, fraction_size SMALLINT DEFAULT 2 NOT NULL, UNIQUE (code), UNIQUE (symbol));

CREATE TABLE category (id INTEGER CONSTRAINT PK_CATEGORY PRIMARY KEY AUTOINCREMENT NOT NULL, type SMALLINT DEFAULT 0 NOT NULL, name VARCHAR(64) NOT NULL, parent_id INTEGER, CONSTRAINT fk_category_parent_category FOREIGN KEY (parent_id) REFERENCES category(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_refbooks', 'atronah', '../changelog/init/create-refbooks.xml', CURRENT_TIMESTAMP, 1, '7:6351918a834a05daf83dde96387a8974', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-person.xml::create_person::atronah
CREATE TABLE person (id INTEGER CONSTRAINT PK_PERSON PRIMARY KEY AUTOINCREMENT NOT NULL, short_name VARCHAR(32) NOT NULL, full_name VARCHAR(255) DEFAULT '' NOT NULL, type SMALLINT DEFAULT 0 NOT NULL);

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_person', 'atronah', '../changelog/init/create-person.xml', CURRENT_TIMESTAMP, 2, '7:55332778ad21ace5694bb4cda4ccaad2', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-user.xml::create_user::atronah
CREATE TABLE user (id INTEGER CONSTRAINT PK_USER PRIMARY KEY AUTOINCREMENT NOT NULL, login VARCHAR(32) NOT NULL, password VARCHAR(255) NOT NULL, person_id INTEGER NOT NULL, CONSTRAINT fk_user_person FOREIGN KEY (person_id) REFERENCES person(id), UNIQUE (login));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_user', 'atronah', '../changelog/init/create-user.xml', CURRENT_TIMESTAMP, 3, '7:31e27d1ecffbcc7c1ccb5130a9481a7a', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-product.xml::create_product::atronah
CREATE TABLE product (id INTEGER CONSTRAINT PK_PRODUCT PRIMARY KEY AUTOINCREMENT NOT NULL, code VARCHAR(128) DEFAULT '' NOT NULL, name VARCHAR(64) NOT NULL, maker_id INTEGER, category_id INTEGER, CONSTRAINT fk_Product_Maker_Person FOREIGN KEY (maker_id) REFERENCES Person(id), CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES category(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_product', 'atronah', '../changelog/init/create-product.xml', CURRENT_TIMESTAMP, 4, '7:d4dcc8feefcfc5fa758ac4e8b403b31a', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-invoice.xml::create_invoice::atronah
CREATE TABLE invoice (id INTEGER CONSTRAINT PK_INVOICE PRIMARY KEY AUTOINCREMENT NOT NULL, created TEXT NOT NULL, completed TEXT, expired TEXT, type SMALLINT DEFAULT 0 NOT NULL, name VARCHAR(64) NOT NULL, amount BIGINT NOT NULL, currency_id INTEGER, discount BIGINT DEFAULT 0 NOT NULL, tax BIGINT DEFAULT 0 NOT NULL, note TEXT DEFAULT '' NOT NULL, ref_invoice_id INTEGER, ref_type SMALLINT DEFAULT 0 NOT NULL, supplier_id INTEGER, customer_id INTEGER, CONSTRAINT fk_invoice_currency FOREIGN KEY (currency_id) REFERENCES currency(id), CONSTRAINT fk_invoice_invoice FOREIGN KEY (ref_invoice_id) REFERENCES invoice(id), CONSTRAINT fk_invoice_customer_person FOREIGN KEY (customer_id) REFERENCES person(id), CONSTRAINT fk_invoice_Supplier_person FOREIGN KEY (supplier_id) REFERENCES person(id));

CREATE TABLE purchase (id INTEGER CONSTRAINT PK_PURCHASE PRIMARY KEY AUTOINCREMENT NOT NULL, invoice_id INTEGER NOT NULL, quantity DECIMAL(15, 5) DEFAULT 1.0 NOT NULL, unit_id INTEGER, price BIGINT NOT NULL, discount BIGINT DEFAULT 0 NOT NULL, tax BIGINT DEFAULT 0 NOT NULL, is_aproximate SMALLINT DEFAULT 0 NOT NULL, CONSTRAINT fk_purchase_invoice FOREIGN KEY (invoice_id) REFERENCES invoice(id), CONSTRAINT fk_purchase_unit FOREIGN KEY (unit_id) REFERENCES unit(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_invoice', 'atronah', '../changelog/init/create-invoice.xml', CURRENT_TIMESTAMP, 5, '7:2226c228a41c626c0ecf5ab00953e847', 'createTable (x2)', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-account.xml::create_account::atronah
CREATE TABLE account_type (id INTEGER CONSTRAINT PK_ACCOUNT_TYPE PRIMARY KEY AUTOINCREMENT NOT NULL, name VARCHAR(64) NOT NULL, is_cash SMALLINT DEFAULT 0 NOT NULL);

CREATE TABLE account (id INTEGER CONSTRAINT PK_ACCOUNT PRIMARY KEY AUTOINCREMENT NOT NULL, created TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL, opened TEXT, closed TEXT, name VARCHAR(64) NOT NULL, description VARCHAR(255) DEFAULT '' NOT NULL, type_id INTEGER NOT NULL, owner_id INTEGER NOT NULL, CONSTRAINT fk_account_owner_person FOREIGN KEY (owner_id) REFERENCES person(id), CONSTRAINT fk_account_type FOREIGN KEY (type_id) REFERENCES account_type(id));

CREATE TABLE balance (id INTEGER CONSTRAINT PK_BALANCE PRIMARY KEY AUTOINCREMENT NOT NULL, account_id INTEGER NOT NULL, checked TEXT NOT NULL, amount BIGINT NOT NULL, currency_id INTEGER, CONSTRAINT fk_balance_account FOREIGN KEY (account_id) REFERENCES account(id), CONSTRAINT fk_balance_currency FOREIGN KEY (currency_id) REFERENCES currency(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_account', 'atronah', '../changelog/init/create-account.xml', CURRENT_TIMESTAMP, 6, '7:4b47f1103d29004edf86bed5babeb0f2', 'createTable (x3)', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/init/create-operation.xml::create_operation::atronah
CREATE TABLE operation (id INTEGER CONSTRAINT PK_OPERATION PRIMARY KEY AUTOINCREMENT NOT NULL, account_id INTEGER NOT NULL, created TEXT DEFAULT CURRENT_TIMESTAMP NOT NULL, performed TEXT, canceled TEXT, amount BIGINT NOT NULL, currency_id INTEGER NOT NULL, direction SMALLINT DEFAULT 0 NOT NULL, performer_id INTEGER NOT NULL, invoice_id INTEGER, CONSTRAINT fk_operation_currency_id FOREIGN KEY (currency_id) REFERENCES currency(id), CONSTRAINT fk_operation_account_id FOREIGN KEY (account_id) REFERENCES account(id), CONSTRAINT fk_operation_perform_person_id FOREIGN KEY (performer_id) REFERENCES person(id), CONSTRAINT fk_operation_invoice_id FOREIGN KEY (invoice_id) REFERENCES invoice(id));

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('create_operation', 'atronah', '../changelog/init/create-operation.xml', CURRENT_TIMESTAMP, 7, '7:89f20e8b4ba79151933d6af7b34b74c8', 'createTable', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::RUR::atronah
INSERT INTO currency (code, idx, name, symbol, fraction_size) VALUES ('RUR', '0', 'Российский рубль', '₽', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('RUR', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 8, '7:d16923b1ba3e4219850b6ec839b9041e', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::USD::atronah
INSERT INTO currency (code, idx, name, symbol, fraction_size) VALUES ('USD', '1', 'Доллар США', '$', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('USD', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 9, '7:7ef288a4b56d22f4ca28e3c9d0beebad', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::EUR::atronah
INSERT INTO currency (code, idx, name, symbol, fraction_size) VALUES ('EUR', '2', 'Евро', '€', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('EUR', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 10, '7:c7765a96ba88e0bc4670305ce6e80a89', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Changeset ../changelog/data/insert-primary-currency.xml::TRY::atronah
INSERT INTO currency (code, idx, name, symbol, fraction_size) VALUES ('TRY', '3', 'Турецкая лира', '₺', '2');

INSERT INTO DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE) VALUES ('TRY', 'atronah', '../changelog/data/insert-primary-currency.xml', CURRENT_TIMESTAMP, 11, '7:c6f06eafae6ee60f1084c295d36f1e91', 'insert', '', 'EXECUTED', NULL, NULL, '3.4.2');

-- Release Database Lock
UPDATE DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

