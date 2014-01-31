/*
* Operations in landportal db
*/
USE landportal

/* Regions */
CREATE TABLE Regions (
    idRegion int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    shape VARCHAR(20),
    PRIMARY KEY (idRegion)
    ) ENGINE=InnoDB;

/* Countries */
CREATE TABLE Countries (
    idCountry int(11) NOT NULL AUTO_INCREMENT,
    idRegion int(11) NOT NULL,
    faoURI VARCHAR(40),
    iso_code2 VARCHAR(20),
    iso_code3 VARCHAR(20),
    PRIMARY KEY (idCountry),
    FOREIGN KEY (idRegion)
    REFERENCES Regions (idRegion)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* Observatios*/
CREATE TABLE Observatios (
    idObservation int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    PRIMARY KEY (idObservation)
    ) ENGINE=InnoDB;

/* Slices */
CREATE TABLE Slices (
    idSlice int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    PRIMARY KEY (idSlice)
    ) ENGINE=InnoDB;

/* Indicators */
CREATE TABLE Indicators (
    idIndicator int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idIndicator)
    ) ENGINE=InnoDB;

/* Licenses */
CREATE TABLE Licenses (
    idLicense int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idLicense)
    ) ENGINE=InnoDB;

/* MeasurementUnits */
CREATE TABLE MeasurementUnits (
    idMeasurementUnit int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idMeasurementUnit)
    ) ENGINE=InnoDB;

/* Values */
CREATE TABLE aValues (
    idAValue int(11) NOT NULL AUTO_INCREMENT,
    value VARCHAR(20),
    PRIMARY KEY (idAValue)
    ) ENGINE=InnoDB;

/* Expressions */
CREATE TABLE Expressions (
    idExpression int(11) NOT NULL AUTO_INCREMENT,
    idAValue int(11) NOT NULL,
    value VARCHAR(20),
    PRIMARY KEY (idExpression),
    FOREIGN KEY (idAValue)
    REFERENCES aValues (idAValue)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* FloatValues */
CREATE TABLE FloatValues (
    idFloatValue int(11) NOT NULL AUTO_INCREMENT,
    idAValue int(11) NOT NULL,
    value VARCHAR(20),
    PRIMARY KEY (idFloatValue),
    FOREIGN KEY (idAValue)
    REFERENCES aValues (idAValue)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* Missings */
CREATE TABLE Missings (
    idMissing int(11) NOT NULL AUTO_INCREMENT,
    idAValue int(11) NOT NULL,
    value VARCHAR(20),
    PRIMARY KEY (idMissing),
    FOREIGN KEY (idAValue)
    REFERENCES aValues (idAValue)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* Comptations */
CREATE TABLE Computations (
    idComputation int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idComputation)
    ) ENGINE=InnoDB;

/* Times */
CREATE TABLE Times (
    idTime int(11) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (idTime)
    ) ENGINE=InnoDB;

/* Instants */
CREATE TABLE Instants (
    idInstant int(11) NOT NULL AUTO_INCREMENT,
    idTime int(11) NOT NULL,
    instant TIMESTAMP,
    PRIMARY KEY (idInstant),
    FOREIGN KEY (idTime)
    REFERENCES Times (idTime)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* Intervals */
CREATE TABLE Intervals (
    idInterval int(11) NOT NULL AUTO_INCREMENT,
    idTime int(11) NOT NULL,
    startTime TIMESTAMP,
    endTime TIMESTAMP,
    PRIMARY KEY (idInterval),
    FOREIGN KEY (idTime)
    REFERENCES Times (idTime)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* YearInterval */
CREATE TABLE YearInterval (
    idYearInterval int(11) NOT NULL AUTO_INCREMENT,
    idInterval int(11) NOT NULL,
    startYear INTEGER,
    endYear INTEGER,
    PRIMARY KEY (idYearInterval),
    FOREIGN KEY (idInterval)
    REFERENCES Intervals (idInterval)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

/* Organizations */
CREATE TABLE Organizations (
    idOrganization int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idOrganization)
    ) ENGINE=InnoDB;

/* DataSources */
CREATE TABLE DataSources (
    idDataSource int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idDataSource)
    ) ENGINE=InnoDB;

/* Datasets */
CREATE TABLE Datasets (
    idDataset int(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(20),
    description VARCHAR(40),
    PRIMARY KEY (idDataset)
    ) ENGINE=InnoDB;

/* Frequencies */
CREATE TABLE Frequencies (
    idFrequency int(11) NOT NULL AUTO_INCREMENT,
    frequency VARCHAR(20),
    PRIMARY KEY (idFrequency)
    ) ENGINE=InnoDB;

