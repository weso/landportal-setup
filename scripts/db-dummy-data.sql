/* Select the database */
USE landportal;

/* Delete previous data */
DELETE FROM Observations;
DELETE FROM Countries;
DELETE FROM Regions;
DELETE FROM Instants;
DELETE FROM Intervals;
DELETE FROM YearInterval;
DELETE FROM Times;
DELETE FROM aValues;
DELETE FROM MeasurementUnits;
DELETE FROM Organizations;
DELETE FROM Indicators;
DELETE FROM Licenses;
DELETE FROM Frequencies;
DELETE FROM DataSources;
DELETE FROM Datasets;
DELETE FROM Slices;
DELETE FROM Computations;

/* Insert dummy data */
INSERT INTO Regions (idRegion, name, shape)
VALUES 
	(1, 'France', ''),
	(2, 'Spain', ''),
	(3, 'Peru', '');

INSERT INTO Countries (idCountry, idRegion, faoURI, iso_code2, iso_code3)
VALUES
	(1, 1, 'http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/France', 'FR', 'FRA'),
	(2, 2, 'http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/Spain', 'ES', 'ESP'),
	(3, 3, 'http://www.fao.org/countryprofiles/geoinfo/geopolitical/resource/Peru', 'PE', 'PER');

INSERT INTO MeasurementUnits (idMeasurementUnit, name, description)
VALUES
	(1, 'Euro', '');

INSERT INTO aValues (idAValue, value)
VALUES
	(1, 2000),
	(2, 25000);

INSERT INTO Times (idTime)
VALUES
	(1),
	(2);

INSERT INTO Intervals (idInterval, idTime, startTime, endTime)
VALUES
	(1, 1, '2010-01-01 00:00:00', '2011-01-01 00:00:00');

INSERT INTO YearInterval (idYearInterval, idInterval, startYear, endYear)
VALUES
	(1, 1, 2010, 2010);

INSERT INTO Instants (idInstant, idTime, instant)
VALUES
	(1, 2, '2014-02-05 00:00:00');

INSERT INTO Licenses (idLicense, name, description)
VALUES
	(1, 'Test license', '');

INSERT INTO Indicators (idIndicator, name, description, idLicense)
VALUES
	(1, 'donation', '', 1),
	(2, 'receiver', '', 1);

INSERT INTO Organizations (idOrganization, name, description)
VALUES
	(1, 'OECD', '');

INSERT INTO DataSources (idDataSource, name, description, idOrganization)
VALUES
	(1, 'OECD', '', 1);

INSERT INTO Frequencies (idFrequency, frequency)
VALUES
	(1, 'annual');

INSERT INTO Datasets (idDataset, name, description, idDataSource, idFrequency)
VALUES
	(1, 'Test dataset', '', 1, 1);

INSERT INTO Slices (idSlice, name, idIndicator, idDataset)
VALUES
	(1, 'slice1', 1, 1);

INSERT INTO Computations (idComputation, name, description)
VALUES
	(1, 'raw', '');

INSERT INTO Observations (idObservation, idRegion, name, idSlice, idDataSource, idIndicator, idMeasurementUnit, idAValue, idComputation, idInstant, idTime)
VALUES
	(1, 1, 'obs2456', 1, 1, 1, 1, 2, 1, 1, 1),
	(2, 2, 'obs2145', 1, 1, 1, 1, 1, 1, 1, 1),
	(3, 3, 'obs2682', 1, 1, 2, 1, 1, 1, 1, 1),
	(4, 3, 'obs9911', 1, 1, 2, 1, 1, 1, 1, 1);



