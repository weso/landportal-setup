/* Create landportal db if not exists */
DROP DATABASE IF EXISTS landportal;
CREATE DATABASE landportal CHARSET = utf8
COLLATE = utf8_general_ci;
USE landportal;

/* Grant all privileges to landportal db user */
GRANT ALL PRIVILEGES ON landportal.* TO
lpuser@localhost IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;

/* Regions */
CREATE TABLE Regions (
    idRegion INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    shape VARCHAR(200),
    PRIMARY KEY (idRegion)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Countries */
CREATE TABLE Countries (
    idCountry INT NOT NULL AUTO_INCREMENT,
    idRegion INT NOT NULL,
    faoURI VARCHAR(200),
    iso_code2 VARCHAR(20),
    iso_code3 VARCHAR(20),
    PRIMARY KEY (idCountry),
    FOREIGN KEY (idRegion)
    REFERENCES Regions (idRegion)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Observations*/
CREATE TABLE Observations (
    idObservation INT NOT NULL AUTO_INCREMENT,
    idRegion INT NOT NULL,
    name VARCHAR(100),
    PRIMARY KEY (idObservation),
    /* Region has Observations*/
    FOREIGN KEY (idRegion)
    REFERENCES Regions(idRegion),
    /* Observation slice */
    idSlice INT NOT NULL
    REFERENCES Slices(idSlice),
    /* Observation provider */
    idDataSource INT NOT NULL
    REFERENCES DataSources(idDataSource),
    /* Observation indicator*/
    idIndicator INT NOT NULL
    REFERENCES Indicators(idIndicator),
    /* Observation measureUnit */
    idMeasurementUnit INT NOT NULL
    REFERENCES MeasurementUnits(idMeasurementUnit),
    /* Observation value */
    idAValue INT NOT NULL
    REFERENCES aValues(idAValue),
    /* Observation computation */
    idComputation INT NOT NULL
    REFERENCES Computations(idComputation),
    /* Observation issued */
    idInstant INT NOT NULL
    REFERENCES Instants(idInstant),
    /* Observation ref-time */
    idTime INT NOT NULL
    REFERENCES Times(idTime)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Slices */
CREATE TABLE Slices (
    idSlice INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    PRIMARY KEY (idSlice),
    /* Slice indicator */
    idIndicator INT NOT NULL
    REFERENCES Indicators(idIndicator),
    /* Observation dataset */
    idDataset INT NOT NULL
    REFERENCES Datasets(idDataset)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Indicators */
CREATE TABLE Indicators (
    idIndicator INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idIndicator),
    /* Indicator license */
    idLicense INT NOT NULL
    REFERENCES Licenses(idLicense)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Licenses */
CREATE TABLE Licenses (
    idLicense INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idLicense)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* MeasurementUnits */
CREATE TABLE MeasurementUnits (
    idMeasurementUnit INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idMeasurementUnit)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Values */
CREATE TABLE aValues (
    idAValue INT NOT NULL AUTO_INCREMENT,
    value VARCHAR(20),
    PRIMARY KEY (idAValue)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Expressions */
CREATE TABLE Expressions (
    idExpression INT NOT NULL AUTO_INCREMENT,
    idAValue INT NOT NULL,
    value VARCHAR(20),
    PRIMARY KEY (idExpression),
    FOREIGN KEY (idAValue)
    REFERENCES aValues (idAValue)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* FloatValues */
CREATE TABLE FloatValues (
    idFloatValue INT NOT NULL AUTO_INCREMENT,
    idAValue INT NOT NULL,
    value VARCHAR(20),
    PRIMARY KEY (idFloatValue),
    FOREIGN KEY (idAValue)
    REFERENCES aValues (idAValue)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Missings */
CREATE TABLE Missings (
    idMissing INT NOT NULL AUTO_INCREMENT,
    idAValue INT NOT NULL,
    value VARCHAR(20),
    PRIMARY KEY (idMissing),
    FOREIGN KEY (idAValue)
    REFERENCES aValues (idAValue)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Computations */
CREATE TABLE Computations (
    idComputation INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idComputation)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Times */
CREATE TABLE Times (
    idTime INT NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idTime)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Instants */
CREATE TABLE Instants (
    idInstant INT NOT NULL AUTO_INCREMENT,
    idTime INT NOT NULL,
    instant TIMESTAMP,
    PRIMARY KEY (idInstant),
    FOREIGN KEY (idTime)
    REFERENCES Times (idTime)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Intervals */
CREATE TABLE Intervals (
    idInterval INT NOT NULL AUTO_INCREMENT,
    idTime INT NOT NULL,
    startTime TIMESTAMP,
    endTime TIMESTAMP,
    PRIMARY KEY (idInterval),
    FOREIGN KEY (idTime)
    REFERENCES Times (idTime)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* YearInterval */
CREATE TABLE YearInterval (
    idYearInterval INT NOT NULL AUTO_INCREMENT,
    idInterval INT NOT NULL,
    startYear INTEGER,
    endYear INTEGER,
    PRIMARY KEY (idYearInterval),
    FOREIGN KEY (idInterval)
    REFERENCES Intervals (idInterval)
    ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Organizations */
CREATE TABLE Organizations (
    idOrganization INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idOrganization)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* DataSources */
CREATE TABLE DataSources (
    idDataSource INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idDataSource),
    /* Datasource organization */
    idOrganization INT NOT NULL
    REFERENCES Organizations(idOrganization)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Datasets */
CREATE TABLE Datasets (
    idDataset INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100),
    description VARCHAR(400),
    PRIMARY KEY (idDataset),
    /* Datasets source */
    idDataSource INT NOT NULL
    REFERENCES DataSources(idDataSource),
    /* Datasets frequency */
    idFrequency INT NOT NULL
    REFERENCES Frequencies(idFrequency)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

/* Frequencies */
CREATE TABLE Frequencies (
    idFrequency INT NOT NULL AUTO_INCREMENT,
    frequency VARCHAR(20),
    PRIMARY KEY (idFrequency)
    ) ENGINE=InnoDB DEFAULT CHARSET = utf8;

