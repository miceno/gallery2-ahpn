## mysql
# UserinfoMap
CREATE TABLE DB_TABLE_PREFIXUserinfoMap(
 DB_COLUMN_PREFIXid int(11) NOT NULL,
 DB_COLUMN_PREFIXuserId varchar(128),
 DB_COLUMN_PREFIXuserName varchar(128),
 DB_COLUMN_PREFIXipAddress varchar(255),
 DB_COLUMN_PREFIXtimeStamp varchar(128),
 DB_COLUMN_PREFIXaction varchar(128),
 PRIMARY KEY(DB_COLUMN_PREFIXid)
) DB_TABLE_TYPE
/*!40100 DEFAULT CHARACTER SET utf8 */;

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoMap', 1, 0);

# UserinfoSetupMap
CREATE TABLE DB_TABLE_PREFIXUserinfoSetupMap(
 DB_COLUMN_PREFIXrowId int(11) NOT NULL,
 DB_COLUMN_PREFIXuiPerPage int(11),
 DB_COLUMN_PREFIXuiDefaultSortColumn varchar(128),
 DB_COLUMN_PREFIXuiDefaultSortOrder varchar(128),
 DB_COLUMN_PREFIXuiDateFormat varchar(255),
 PRIMARY KEY(DB_COLUMN_PREFIXrowId)
) DB_TABLE_TYPE
/*!40100 DEFAULT CHARACTER SET utf8 */;

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoSetupMap', 1, 0);

## postgres
# UserinfoMap
CREATE TABLE DB_TABLE_PREFIXUserinfoMap(
 DB_COLUMN_PREFIXid INTEGER NOT NULL,
 DB_COLUMN_PREFIXuserId VARCHAR(128),
 DB_COLUMN_PREFIXuserName VARCHAR(128),
 DB_COLUMN_PREFIXipAddress VARCHAR(255),
 DB_COLUMN_PREFIXtimeStamp VARCHAR(128),
 DB_COLUMN_PREFIXaction VARCHAR(128)
);

ALTER TABLE DB_TABLE_PREFIXUserinfoMap ADD PRIMARY KEY (DB_COLUMN_PREFIXid);

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoMap', 1, 0);

# UserinfoSetupMap
CREATE TABLE DB_TABLE_PREFIXUserinfoSetupMap(
 DB_COLUMN_PREFIXrowId INTEGER NOT NULL,
 DB_COLUMN_PREFIXuiPerPage INTEGER,
 DB_COLUMN_PREFIXuiDefaultSortColumn VARCHAR(128),
 DB_COLUMN_PREFIXuiDefaultSortOrder VARCHAR(128),
 DB_COLUMN_PREFIXuiDateFormat VARCHAR(255)
);

ALTER TABLE DB_TABLE_PREFIXUserinfoSetupMap ADD PRIMARY KEY (DB_COLUMN_PREFIXrowId);

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoSetupMap', 1, 0);

## oracle
# UserinfoMap
CREATE TABLE DB_TABLE_PREFIXUserinfoMap(
 DB_COLUMN_PREFIXid INTEGER NOT NULL,
 DB_COLUMN_PREFIXuserId VARCHAR2(128),
 DB_COLUMN_PREFIXuserName VARCHAR2(128),
 DB_COLUMN_PREFIXipAddress VARCHAR2(255),
 DB_COLUMN_PREFIXtimeStamp VARCHAR2(128),
 DB_COLUMN_PREFIXaction VARCHAR2(128)
);

ALTER TABLE DB_TABLE_PREFIXUserinfoMap
 ADD PRIMARY KEY (DB_COLUMN_PREFIXid)
;

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoMap', 1, 0);

# UserinfoSetupMap
CREATE TABLE DB_TABLE_PREFIXUserinfoSetupMap(
 DB_COLUMN_PREFIXrowId INTEGER NOT NULL,
 DB_COLUMN_PREFIXuiPerPage INTEGER,
 DB_COLUMN_PREFIXuiDefaultSortColumn VARCHAR2(128),
 DB_COLUMN_PREFIXuiDefaultSortOrder VARCHAR2(128),
 DB_COLUMN_PREFIXuiDateFormat VARCHAR2(255)
);

ALTER TABLE DB_TABLE_PREFIXUserinfoSetupMap
 ADD PRIMARY KEY (DB_COLUMN_PREFIXrowId)
;

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoSetupMap', 1, 0);

## db2
# UserinfoMap
CREATE TABLE DB_TABLE_PREFIXUserinfoMap(
 DB_COLUMN_PREFIXid INTEGER NOT NULL,
 DB_COLUMN_PREFIXuserId VARCHAR(128),
 DB_COLUMN_PREFIXuserName VARCHAR(128),
 DB_COLUMN_PREFIXipAddress VARCHAR(255),
 DB_COLUMN_PREFIXtimeStamp VARCHAR(128),
 DB_COLUMN_PREFIXaction VARCHAR(128)
);

ALTER TABLE DB_TABLE_PREFIXUserinfoMap ADD PRIMARY KEY (DB_COLUMN_PREFIXid);

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoMap', 1, 0);

# UserinfoSetupMap
CREATE TABLE DB_TABLE_PREFIXUserinfoSetupMap(
 DB_COLUMN_PREFIXrowId INTEGER NOT NULL,
 DB_COLUMN_PREFIXuiPerPage INTEGER,
 DB_COLUMN_PREFIXuiDefaultSortColumn VARCHAR(128),
 DB_COLUMN_PREFIXuiDefaultSortOrder VARCHAR(128),
 DB_COLUMN_PREFIXuiDateFormat VARCHAR(255)
);

ALTER TABLE DB_TABLE_PREFIXUserinfoSetupMap ADD PRIMARY KEY (DB_COLUMN_PREFIXrowId);

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoSetupMap', 1, 0);

## mssql
# UserinfoMap
CREATE TABLE DB_TABLE_PREFIXUserinfoMap(
 DB_COLUMN_PREFIXid INT NOT NULL,
 DB_COLUMN_PREFIXuserId NVARCHAR(128) NULL,
 DB_COLUMN_PREFIXuserName NVARCHAR(128) NULL,
 DB_COLUMN_PREFIXipAddress NVARCHAR(255) NULL,
 DB_COLUMN_PREFIXtimeStamp NVARCHAR(128) NULL,
 DB_COLUMN_PREFIXaction NVARCHAR(128) NULL
);

ALTER TABLE DB_TABLE_PREFIXUserinfoMap ADD PRIMARY KEY (DB_COLUMN_PREFIXid);

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoMap', 1, 0);

# UserinfoSetupMap
CREATE TABLE DB_TABLE_PREFIXUserinfoSetupMap(
 DB_COLUMN_PREFIXrowId INT NOT NULL,
 DB_COLUMN_PREFIXuiPerPage INT NULL,
 DB_COLUMN_PREFIXuiDefaultSortColumn NVARCHAR(128) NULL,
 DB_COLUMN_PREFIXuiDefaultSortOrder NVARCHAR(128) NULL,
 DB_COLUMN_PREFIXuiDateFormat NVARCHAR(255) NULL
);

ALTER TABLE DB_TABLE_PREFIXUserinfoSetupMap ADD PRIMARY KEY (DB_COLUMN_PREFIXrowId);

INSERT INTO DB_TABLE_PREFIXSchema (
 DB_COLUMN_PREFIXname,
 DB_COLUMN_PREFIXmajor,
 DB_COLUMN_PREFIXminor
) VALUES('UserinfoSetupMap', 1, 0);

