CREATE TABLE robot (
    robotid VARCHAR(30),
    available BOOL NOT NULL DEFAULT true,
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
    deliverynumber INTEGER NOT NULL,
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
    groupid INTEGER NOT NULL,
    robotid VARCHAR(30) NOT NULL,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (robotid) REFERENCES robot(robotid)
);

CREATE TABLE rents (
    renteeid INTEGER NOT NULL,
    groupid SERIAL NOT NULL,
    rentStart TIMESTAMP NOT NULL,
    rentEnd TIMESTAMP,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (groupid)
);

CREATE TABLE heatmap(
    groupid INTEGER NOT NULL,,
    originX NUMERIC,
    originY NUMERIC,
    scale NUMERIC,
    angle NUMERIC,
    reflectionX NUMERIC,
    reflectionY NUMERIC,
    height NUMERIC,
    FOREIGN KEY (groupid) REFERENCES rents(groupid)
);
--------------------------------------------------

CREATE FUNCTION distancepertime (
	timedis VARCHAR,
	robot VARCHAR,
	begining TIMESTAMP,
    enddate TIMESTAMP
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
            WHERE robotposition.robotid=robot and robotposition.ts > begining and robotposition.ts < enddate
            GROUP BY groupedTime;
    END;
$$


CREATE PROCEDURE rent(
    rentee INTEGER,
    numberRobots INTEGER,
    begining TIMESTAMP
)   
LANGUAGE PLPGSQL
AS $$
    
   DECLARE 
        groupidentifier INTEGER;
        robotCursor CURSOR FOR SELECT robotid FROM robot WHERE available = true LIMIT numberRobots;
		currentRobot VARCHAR;
    BEGIN
        WITH grouptable AS (
		 INSERT INTO rents (renteeid,rentstart) VALUES (rentee,begining) RETURNING rents.groupid
		)SELECT groupid INTO groupidentifier from grouptable;
        OPEN robotCursor;
			loop
			FETCH FROM robotCursor INTO currentRobot;
			IF NOT FOUND THEN
				EXIT;
			END IF;
			INSERT INTO grouprobots (robotid,groupid) values (currentRobot, groupidentifier);
			UPDATE robot SET available = false where robotid = currentRobot;
			end loop;
		CLOSE robotCursor;
		
		RETURN 1;
    END;
;
$$

CREATE FUNCTION terminaterent(
    terminategroup INTEGER
)   
RETURNS TIMESTAMP
AS $$
      
   	DECLARE 
        robotgroupcursor CURSOR FOR SELECT robotid FROM groupRobots WHERE groupid = terminateGroup;
		currentRobot VARCHAR;
        rentendtimestamp TIMESTAMP;
    BEGIN
        WITH currRent as(
        	UPDATE rents SET rentEnd = CURRENT_TIMESTAMP where groupid = terminateGroup RETURNING rentEnd
        )SELECT rentend into rentendtimestamp from currRent;

        OPEN robotgroupcursor;
			loop
			FETCH FROM robotgroupcursor INTO currentRobot;
			IF NOT FOUND THEN
				EXIT;
			END IF;
			    UPDATE robot SET available = true where robotid = currentRobot;
			end loop;
		CLOSE robotgroupcursor;
		RETURN rentendtimestamp;
    END;;
$$
LANGUAGE PLPGSQL;

CREATE FUNCTION groupdistancepertime (
    timedis VARCHAR,
	groupi INTEGER
) 
	RETURNS TABLE (
        ts TIMESTAMP,
    	distance DOUBLE PRECISION
	)
	LANGUAGE plpgsql
AS $$
   BEGIN
		RETURN QUERY
            SELECT DATE_TRUNC(timedis,robotposition.ts)  AS  groupedTime, SUM(robotposition.distance)
            FROM robotposition
            WHERE robotid in 
                    (SELECT robotid 
                    FROM grouprobots WHERE groupid = groupi) 
                AND robotposition.ts BETWEEN 
                    (SELECT rentstart 
                    FROM rents 
                    WHERE groupid = groupi) 
                    AND 
                    (SELECT COALESCE(rentend, CURRENT_TIMESTAMP) 
                    FROM rents 
                    WHERE groupid = groupi)
            GROUP BY groupedTime;
    END;
$$


CREATE FUNCTION groupdeliveriespertime (
    timedis VARCHAR,
	groupi INTEGER
) 
	RETURNS TABLE (
        ts TIMESTAMP,
    	delivery BIGINT
	)
	LANGUAGE plpgsql
AS $$
   BEGIN
		RETURN QUERY
            SELECT DATE_TRUNC(timedis,delivery.deliveryrequest)  AS  groupedTime, COUNT(*)
            FROM delivery
            WHERE robotid in 
                    (SELECT robotid 
                    FROM grouprobots WHERE groupid = groupi) 
                AND delivery.deliveryrequest BETWEEN 
                    (SELECT rentstart 
                    FROM rents 
                    WHERE groupid = groupi) 
                    AND 
                    (SELECT COALESCE(rentend, CURRENT_TIMESTAMP) 
                    FROM rents 
                    WHERE groupid = groupi)
            GROUP BY groupedTime;
    END;
$$

CREATE FUNCTION grouprobotpositions (
    groupi INTEGER
) 
	RETURNS TABLE (
        x NUMERIC,
        y NUMERIC,
        total BIGINT
	)
	LANGUAGE plpgsql
AS $$
   BEGIN
		RETURN QUERY

            SELECT ROUND(robotposition.x::NUMERIC,1) as thisx, ROUND(robotposition.y::NUMERIC,1) as thisy, count(*) as counter
            FROM robotposition
            WHERE robotid in 
                    (SELECT robotid 
                    FROM grouprobots WHERE groupid = groupi) 
                AND robotposition.ts BETWEEN 
                    (SELECT rentstart 
                    FROM rents 
                    WHERE groupid = groupi) 
                    AND 
                    (SELECT COALESCE(rentend, CURRENT_TIMESTAMP) 
                    FROM rents 
                    WHERE groupid = groupi)
            GROUP BY thisx,thisy
            ORDER BY counter DESC; 
    END;
$$