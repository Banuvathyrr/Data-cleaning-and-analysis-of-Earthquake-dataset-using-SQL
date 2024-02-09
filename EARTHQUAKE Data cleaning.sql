create schema earthquake;
use earthquake;

-- DATA DISCOVERY--
SELECT 
	*
FROM 
	eqdatabase;
	
    
-- TO CHECK THE DATA TYPE OF INDIVIDUAL COLUMNS IN TABLE--
SELECT 
	DATA_TYPE
FROM 
	Information_schema.columns 
WHERE
	table_schema = 'earthquake' and table_name='eqdatabase';
    

-- TO CHECK INCONSISTENCY IN DATE COLUMN--
SELECT 
	length(Date)
FROM 
	eqdatabase;


SELECT 
	MAX(length(date))
FROM
	eqdatabase; -- 24--


SELECT 
	MIN(length(date))
FROM
	eqdatabase; -- 10--


UPDATE 
	eqdatabase
SET 
	date=LEFT(date,10)
WHERE
	length(date)=24;


SELECT 
	MAX(length(date))
FROM
	eqdatabase;-- 10--


-- STANDARDIZE DATE FORMAT--
ALTER TABLE 
	eqdatabase
ADD COLUMN 
	Date2 Date after Date;


UPDATE 
	eqdatabase
SET 
	Date2= str_to_date(`Date`,'%d-%m-%Y');


SELECT 
	Date, 
    str_to_date(Date,'%d-%m-%y')
FROM 
	eqdatabase
WHERE
	str_to_date(Date,'%d-%m-%y') is null;
     

UPDATE 
	eqdatabase
SET 
	Date=replace(Date,'1975-02-23','23-02-1975');


UPDATE 
	eqdatabase
SET 
	Date=replace(Date,'1985-04-28','28-04-1985');

    
UPDATE 
	eqdatabase
SET  
	Date=replace(Date,'2011-03-13','13-03-2011');


UPDATE 
	eqdatabase
SET 
	Date2= str_to_date(`Date`,'%d-%m-%Y');


-- STANDARDIZE TIME FORMAT--
ALTER TABLE 
	eqdatabase
ADD COLUMN 
	Time2 time after Time;


UPDATE 
	eqdatabase
SET 
	Time2=cast(Time as time);


SELECT 
	MAX(length(time))
FROM 
	eqdatabase;


SELECT
	MIN(length(time))
FROM
	eqdatabase;


SELECT
	Time
FROM 
	eqdatabase
WHERE
	length(time) = 24;


UPDATE 
	eqdatabase
SET
	time=replace(time,'1975-02-23T02:58:41.000Z',substr(time,12,8))
WHERE
	time='1975-02-23T02:58:41.000Z';



UPDATE 
	eqdatabase
SET 
	time=replace(time,'1985-04-28T02:53:41.530Z',substr(time,12,8))
WHERE
	time='1985-04-28T02:53:41.530Z';


UPDATE 
	eqdatabase
SET
	time=replace(time,'2011-03-13T02:23:34.520Z',substr(time,12,8))
WHERE
	time='2011-03-13T02:23:34.520Z';



UPDATE 
	eqdatabase
SET 
	Time2=cast(Time as time);


-- HANDLING BLANK ROWS IN Depth Error,Depth Seismic,Magnitude Error, Magnitude Seismic Stations,Azimuthal Gap,Horizontal Distance,
-- Horizontal Error, Root Mean Square

SELECT COUNT(`Depth error`) from eqdatabase where `Depth error`='';
SELECT COUNT(`Depth Seismic Stations`) from eqdatabase where `Depth Seismic Stations`='';
SELECT COUNT(`Magnitude Error`) from eqdatabase where `Magnitude Error`='';
SELECT COUNT(`Magnitude Seismic Stations`) from eqdatabase where `Magnitude Seismic Stations`='';
SELECT COUNT(`Azimuthal Gap`) from eqdatabase where `Azimuthal Gap`='';
SELECT COUNT(`Horizontal Distance`) from eqdatabase where `Horizontal Distance`='';
SELECT COUNT(`Horizontal Error`) from eqdatabase where `Horizontal Error`='';
SELECT COUNT(`Root Mean Square`) from eqdatabase where `Root Mean Square`='';

-- Update zeros in the missing rows of the text columns so that those columns could be changed to double- 
UPDATE eqdatabase
SET `Depth error`= CASE WHEN `Depth error` ='' THEN 0.0
						ELSE `Depth error`
                        END;
                        
UPDATE eqdatabase
SET `Depth Seismic Stations`= CASE WHEN `Depth Seismic Stations` ='' THEN 0.0
						ELSE `Depth Seismic Stations`
                        END;
                       
UPDATE eqdatabase                     
SET `Magnitude Error`= CASE WHEN `Magnitude Error` ='' THEN 0.0
						ELSE `Magnitude Error`
                        END;
                        
UPDATE eqdatabase                     
SET `Magnitude Seismic Stations`= CASE WHEN `Magnitude Seismic Stations` ='' THEN 0.0
						ELSE `Magnitude Seismic Stations`
                        END;

UPDATE eqdatabase                     
SET `Azimuthal Gap`= CASE WHEN `Azimuthal Gap` ='' THEN 0.0
						ELSE `Azimuthal Gap`
                        END;

UPDATE eqdatabase                     
SET `Horizontal Distance`= CASE WHEN `Horizontal Distance` ='' THEN 0.0
						ELSE `Horizontal Distance`
                        END;
                        
UPDATE eqdatabase                     
SET `Horizontal Error`= CASE WHEN `Horizontal Error` ='' THEN 0.0
						ELSE `Horizontal Error`
                        END;
                        
UPDATE eqdatabase                     
SET `Root Mean Square`= CASE WHEN `Root Mean Square` ='' THEN 0.0
						ELSE `Root Mean Square`
                        END;
                        
-- MODIFY THE DATA TYPE OF THE ABOVE TEXT COLUMNS TO DOUBLE--
ALTER TABLE eqdatabase MODIFY COLUMN `Depth error` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Depth Seismic Stations` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Magnitude Error` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Magnitude Seismic Stations` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Azimuthal Gap` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Horizontal Distance` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Horizontal Error` double;
ALTER TABLE eqdatabase MODIFY COLUMN `Root Mean Square` double;

-- TO CHECK FOR DUPLICATES
WITH t1 as 
(SELECT *, row_number() over(partition by Date2,Time2,Latitude,Longitude order by id) as rownum
FROM eqdatabase)
SELECT count(*) from t1 where rownum>1;



-- TO EXTRACT YEAR , MONTH AND DAY FROM Date column
-- EXTRACT YEAR--

SELECT 
	EXTRACT(Year FROM Date2) 
FROM 
	eqdatabase;


ALTER TABLE eqdatabase
ADD COLUMN Year int after Time2;


UPDATE eqdatabase
SET Year= EXTRACT(Year FROM Date2);


-- EXTRACT MONTH--
SELECT EXTRACT(Month FROM Date2) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN Month int after Year;

UPDATE eqdatabase
SET Month= EXTRACT(Month FROM Date2);


-- EXTRACT WEEK--
SELECT WEEK(DATE2,0) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN WEEK int after MONTH;

UPDATE eqdatabase
SET Week= WEEK(DATE2,0);

ALTER TABLE eqdatabase
RENAME COLUMN WEEK TO Week;


-- EXTRACT DAYNAME--
SELECT dayname(DATE2) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN `Day name` character after Week;

UPDATE eqdatabase
SET `Day name`= dayname(DATE2);

ALTER TABLE eqdatabase
MODIFY COLUMN `Day name` character(15) after Week;

UPDATE eqdatabase
SET `Day name`= dayname(DATE2);


-- CHECK FOR OUTLIERS--
select * from eqdatabase where Magnitude < 5.5;
select * from eqdatabase where Year > 2016 or Year < 1965;


-- DROP THE UNNECESSARY COLUMNS--
ALTER TABLE eqdatabase
DROP COLUMN Date,
DROP COLUMN Time;


-- RENAME DATE2 TO DATE AND TIME2 TO TIME
ALTER TABLE eqdatabase
RENAME COLUMN Date2 to Date,
RENAME COLUMN Time2 to Time;


-- DATA ANALYSIS--
SELECT 
	*
FROM 
	eqdatabase;
    
    
-- 1)  What is the distribution of earthquakes over different years, months, and weeks, ?
SELECT 
	YEAR, COUNT(*) AS No_of_EQS
FROM
	eqdatabase
GROUP BY 
	Year
ORDER BY
	No_of_EQS DESC;
-- Maximum number of Earthquakes(713) occurred in the year 2011 and Minimum number of earthquakes happened in th 1966 between the interval 1965 and 2011 


SELECT 
	MONTH, COUNT(*) as No_of_EQS
FROM
	eqdatabase
GROUP BY 
	Month
ORDER BY
	No_of_EQS desc;
-- March and July had a maximum number of Earthquakes followed by December and November 


SELECT 
	WEEK, COUNT(*)
FROM
	eqdatabase
GROUP BY 
	WEEK
ORDER BY
	WEEK asc;
    
    
-- 2) Which year had the highest number of earthquakes?
SELECT 
	YEAR, COUNT(*) as Max_Number_of_EQS
FROM
	eqdatabase
GROUP BY 
	Year
ORDER BY
	Max_Number_of_EQS desc
LIMIT 1;


-- 3) What is the average number of earthquakes per month?
SELECT 
	AVG(num_EQS) AS Avg_EQ
FROM
    (
	SELECT 
		YEAR,
		MONTH,
        COUNT(*) AS num_EQS
	FROM
		eqdatabase
	GROUP BY 
		YEAR,
        MONTH ) AS EQS;
	-- On an average, 37 earthquakes per month--
  
  
-- 4) What are the top regions with the highest number of earthquakes?
SELECT 
	Latitude,
	Longitude,
	COUNT(*) AS num_EQS
FROM
	eqdatabase
GROUP BY 
	Latitude,
	Longitude
ORDER BY
    num_EQS DESC
LIMIT 5;


-- 5) How many earthquakes occurred in each degree of latitude and longitude?
SELECT 
	Latitude,
	Longitude,
	COUNT(*) AS num_EQS
FROM
	eqdatabase
GROUP BY 
	Latitude,
	Longitude
ORDER BY
    num_EQS DESC;
    
    
-- 6) What is the average magnitude of earthquakes for each type?
SELECT 
	DISTINCT (Type)
FROM 
	eqdatabase;

    
SELECT 
	count(*)
FROM 
	eqdatabase
WHERE 
	Type='Nuclear Explosion';
   
   
SELECT 
	DISTINCT(Type),
    round(AVG(Magnitude),2) as Avg_mag
FROM 
	eqdatabase
GROUP BY 
	Type;
    
    
SELECT 
	*
FROM 
	eqdatabase;
    
    
-- 7) How many earthquakes are reported from each source?
SELECT 
	Source, COUNT(*) as EQS_reported
FROM 
	eqdatabase
GROUP BY
	Source
ORDER BY
	EQS_reported DESC;
-- University of Washington reported the maximum number of earthquakes
-- it was then followed by International Seismological Centre Global Earthquake Model
    
    
    
-- 8) What are the different earthquake statuses and their frequencies?
SELECT 
	STATUS, COUNT(*) as Count_of_status
FROM 
	eqdatabase
GROUP BY
	STATUS
ORDER BY
	Count_of_status DESC;
-- Maximum number of EQS were analyzed and reviewed by seismologists or experts. 



WITH CTE AS (
    SELECT 
        STATUS, 
        COUNT(*) AS Count_of_status
    FROM 
        eqdatabase
    GROUP BY 
        STATUS
)
SELECT 
	STATUS, 
    Count_of_status,
	(Count_of_status/ (SELECT SUM(Count_of_status) FROM CTE))*100 AS cct
FROM 
    CTE
ORDER BY cct desc;
-- Almost 88% of the EQS were reviewed while remaining 11% were in the form of Automatic or Preliminary reports



-- 9) How does the frequency of earthquakes vary over time, considering rolling averages or moving averages?
WITH T2 AS
(SELECT
	Year,
    Month,
    Count(*) AS No_of_EQS
FROM
	eqdatabase
GROUP BY
    Year,
    Month)
SELECT 
	Year,
    Month,
	AVG(No_of_EQS) OVER(ORDER BY Year, Month ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING) AS moving_avgs
FROM T2;
-- Moving averages of number of eqs were found to be high for the first 6 months of the 2011..



-- 10) Can we rank earthquakes based on their magnitudes within each year?
WITH Mag AS
(
SELECT 
	Year,
    Latitude,
    Longitude,
    Magnitude,
    RANK() OVER(PARTITION BY Year ORDER BY Magnitude DESC) AS Mag_rank
FROM
	eqdatabase
    )
SELECT
	Year,
    Latitude,
    Longitude,
    Magnitude,
    Mag_rank
FROM Mag;

-- 0R


WITH Mag AS
(
SELECT 
	Year,
    Latitude,
    Longitude,
    Magnitude,
    DENSE_RANK() OVER(PARTITION BY Year ORDER BY Magnitude DESC) AS Mag_rank
FROM
	eqdatabase
    )
SELECT
	Year,
    Latitude,
    Longitude,
    Magnitude,
    Mag_rank
FROM Mag;


-- 11) What are the top regions with the highest number of earthquakes?
SELECT 
	latitude, longitude, COUNT(*) as Number_of_EQS
FROM
	eqdatabase
GROUP BY 
	latitude, longitude
ORDER BY
	Number_of_EQS desc;
    
    
-- 12) Avg magnitude of earthquakes each year--
SELECT 
	YEAR, COUNT(*) as Number_of_EQS, AVG(Magnitude) as Avg_mag
FROM
	eqdatabase
GROUP BY 
	Year
ORDER BY
	Avg_mag desc;
-- Although the number of EQS were 305 in 1968 (nearly half the number of EQS happened in 2011) , Average magnitude of Earthquake was high compared to the other years
  
  
  
-- 13) Number of earthquakes each year--
SELECT 
	YEAR, COUNT(*) as Number_of_EQS, ROUND(AVG(Magnitude),3) as Avg_mag
FROM
	eqdatabase
GROUP BY 
	Year
ORDER BY
	Number_of_EQS desc;
  
-- 14) Highest magnitude of earthquake
SELECT
 *   
 FROM 
 eqdatabase
 WHERE Magnitude=(SELECT MAX(Magnitude) FROM eqdatabase);
 -- Highest magnitude of earthquake (9.1) occurred in 2004 and 2011




 
-- **Insights**
-- When analysing the earthquake data between the year 1965 and 2016, maximum number of earthquakes (713) occurred in the year 2011 and minimum number of earthquakes happened in the year 1966.
-- March and July had a maximum number of earthquakes followed by December and November. Moving averages of number of earthquakes were found to be high for the first 6 months of the 2011. This shows that the first half of the year is more prone to earthquakes.
-- On an average, 37 earthquakes occurred per month
-- University of Washington reported the maximum number of earthquakes
-- it was then followed by International Seismological Centre Global Earthquake Model
-- Almost 88% of the earthquakes were reviewed while remaining 11% were in the form of Automatic or Preliminary reports.
-- In 1968, although the number of earthquakes were 305 , average magnitude of earthquake was higher compared to the other years.
-- Highest magnitude of earthquake (9.1) occurred in the year 2004 and 2011.

