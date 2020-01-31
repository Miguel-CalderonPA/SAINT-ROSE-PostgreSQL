DROP TABLE IF EXISTS hosts;		--}
DROP TABLE IF EXISTS streamingServices; ---} Instruction 1 Drop Tables
DROP TABLE IF EXISTS series;		--}


---------------------Instruction 2 Create Tables---------------------

CREATE TABLE streamingServices (
	serviceName TEXT,
	url TEXT,
	cost NUMERIC,
	PRIMARY KEY (serviceName)
);

CREATE TABLE series (
	seriesID SERIAL,
	seriesNAME TEXT,
	startYear INTEGER,
	endYear INTEGER,
	PRIMARY KEY (seriesID)
);

CREATE TABLE hosts (
	serviceName TEXT,
	seriesID SERIAL,
	PRIMARY KEY (serviceName,seriesID),
	FOREIGN KEY (serviceName) REFERENCES streamingServices(serviceName),
	FOREIGN KEY (seriesID) REFERENCES series(seriesID)
);
---------------------Instruction 3 Insert Data into the Database---------------------
INSERT INTO streamingServices VALUES   --3a 
	('Spotify', 'https://www.spotify.com/us/',0.00),
	('Netflix', 'https://www.netflix.com/',8.99);

SELECT * FROM streamingServices; --testing

INSERT INTO series (seriesName,startYear,endYear) VALUES --3b
	('Locked on Packers', 2017, 2038),--3c (1)
	('Locked on NFL', 2017, 2038),--3c (1)
	('Coding Blocks', 2015, 2038),--3c (2)
	('House of Cards', 2013, 2018),
	('Gotham', 2014, 2019),
	('DareDevil', 2015, 2018);--3c (2)

SELECT * FROM series; -- testing

INSERT INTO hosts (serviceName) VALUES --3d
	('Spotify'),
	('Spotify'),
	('Spotify'),
	('Netflix'),
	('Netflix'),
	('Netflix');

SELECT * FROM hosts; --testing

---------------------------Instruction 4 SeriesName/ServiceName-------------------

SELECT seriesName, serviceName FROM series, hosts
WHERE series.seriesID=hosts.seriesID;

---------------------------Instruction 5 All Series on 1 Platform-------------------

SELECT seriesName, serviceName FROM hosts,series 
WHERE hosts.seriesID = series.seriesID 
AND hosts.serviceName = 'Netflix';

---------------------------Instruction 6 cheapest service to "watch" something-------------------
--When you said streaming services, I didn't immediatly think watching, but spotify is the cheaper

SELECT seriesName, cost FROM hosts,series,streamingServices 
WHERE series.seriesID = hosts.seriesID 
AND streamingServices.serviceName = hosts.serviceName
AND cost=(SELECT min(cost) FROM streamingServices);


---------------------------Instruction 7 Series with same startYear-------------------

SELECT s1.seriesName, s2.seriesName, s2.startYear FROM series as s1, series as s2 
WHERE s1.startYear=s2.startYear AND s1.seriesID < s2.seriesID;


---------------Instruction 8 Cartesion product of series and streamingServies-------------------
/*
Cartesian Product of Series and Streaming Services  (12 Rows Series (6) times Streaming Services (2))

A,B = 	(1, Locked on Packers, 2017, 2038, Spotify, https://www.spotify,com/us/, 0.00)
	(1, Locked on Packers, 2017, 2038, Netflix, https://www.netflix.com, 8.99)

	(2, Locked on NFL, 2017, 2038, Spotify, https://www.spotify.com/us/, 0.00)
	(2, Locked on NFL, 2017, 2038, Netflix, https://www.netflix.com/ 8.99)

	(3, Coding Blocks, 2015, 2038, Spotify, https://www.spotify.com/us/, 0.00)
	(3, Coding Blocks, 2015, 2038, Netflix, https://www.netflix.com/, 8.99)

	(4, House of Cards, 2013, 2018, Spotify, https://www.spotify.com/us/, 0.00)
	(4, House of Cards, 2013, 2018, Netflix, https://www.netflix.com/, 8.99)

	(5, Gotham, 2014, 2019, Spotify, https://www.spotify.com/us/, 0.00)
	(5, Gotham, 2014, 2019, Netflix, https://www.netflix.com/, 8.99)

	(6, DareDevil, 2015, 2018, Spotify, https://www.spotify.com/us/, 0.00)
	(6, DareDevil, 2015, 2018, Netflix, https://www.netflix.com/, 8.99)

*/

---------------------------Instruction 9 Average Length of each Service Series-------------------

SELECT streamingServices.serviceName, avg(series.endYear-series.startyear) FROM series,streamingServices,hosts
WHERE hosts.seriesID=series.seriesID AND hosts.serviceName=streamingServices.serviceName
GROUP BY streamingServices.serviceName;



/* Instruction 0
ERROR:  syntax error at or near "("
LINE 19:  PRIMARY KEY (seriesID)
                      ^
********** Error **********

ERROR: syntax error at or near "("
SQL state: 42601
Character: 430

COMMENT: I forgot the comma on the line prior 
*/
