CREATE TABLE robot (
    robotid VARCHAR(30),
    available BOOL NOT NULL,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(robotid)
);

CREATE TABLE rentee (
    renteeid SMALLSERIAL,
    renteename VARCHAR(30) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL,
    admin BOOL DEFAULT FALSE,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    password VARCHAR(100) NOT NULL,
    PRIMARY KEY(renteeid)
);

CREATE TABLE dropzone(
    dzid SMALLSERIAL,
    dzname VARCHAR(30) NOT NULL,
    renteeid INTEGER NOT NULL,
    PRIMARY KEY (dzid),
    FOREIGN KEY (renteeid) REFERENCES rentee(renteeid)
);

CREATE TABLE delivery (
    deliverynumber INTEGER,
    robotid VARCHAR(30) NOT NULL ,
    dzid INTEGER NOT NULL,
    deliveryRequest TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deliverySent TIMESTAMP,
    deliveryConfirmed TIMESTAMP,
    PRIMARY KEY (deliverynumber),
    FOREIGN KEY (robotid) REFERENCES robot(robotid),
    FOREIGN KEY (dzid) REFERENCES dropzone(dzid)
);

CREATE TABLE robotposition (
    robotid VARCHAR(30) NOT NULL,
    x DOUBLE PRECISION NOT NULL,
    y DOUBLE PRECISION NOT NULL,
    distance DOUBLE PRECISION NOT NULL,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (robotid) REFERENCES robot(robotid)
);


CREATE TABLE groupRobots (
    groupid INTEGER,
    robotid VARCHAR(30) NOT NULL,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (robotid) REFERENCES robot(robotid)
);

CREATE TABLE rents (
    renteeid INTEGER,
    groupid INTEGER,
    rentStart TIMESTAMP NOT NULL,
    rentEnd TIMESTAMP NOT NULL,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------

CREATE FUNCTION distancepertime (
	timedis VARCHAR,
	robot VARCHAR,
	begining TIMESTAMP
) 
	RETURNS TABLE (
        ts TIMESTAMP
    	distance DOUBLE PRECISION
	)
	LANGUAGE plpgsql
AS $$
    BEGIN
		RETURN QUERY
            SELECT DATE_TRUNC(timedis,robotposition.ts)  AS  groupedTime, SUM(robotposition.distance)
            FROM robotposition
            WHERE robotposition.robotid=robot and robotposition.ts > begining
            GROUP BY groupedTime;
    END;
$$
