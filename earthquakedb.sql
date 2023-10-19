create schema earthquake;
use earthquake;

-- DATA DISCOVERY--
select * from eqdatabase;

-- TO CHECK THE DATA TYPE OF INDIVIDUAL COLUMNS IN TABLE--
select DATA_TYPE from Information_schema.columns where
table_schema='earthquake' and table_name='eqdatabase';

-- TO CHECK INCONSISTENCY IN DATE COLUMN--
SELECT length(Date)
from eqdatabase;

SELECT MAX(length(date))
from eqdatabase; -- 24--

SELECT min(length(date))
from eqdatabase; -- 10--

UPDATE eqdatabase
SET date=LEFT(date,10)
where length(date)=24;

SELECT MAX(length(date))
from eqdatabase;-- 10--

-- STANDARDIZE DATE FORMAT--
ALTER TABLE eqdatabase
ADD COLUMN Date2 Date after Date;

UPDATE eqdatabase
SET Date2= str_to_date(`Date`,'%d-%m-%Y');

SELECT Date,str_to_date(Date,'%d-%m-%y')
from eqdatabase
where str_to_date(Date,'%d-%m-%y') is null;

UPDATE eqdatabase
set Date=replace(Date,'1975-02-23','23-02-1975');
UPDATE eqdatabase
set Date=replace(Date,'1985-04-28','28-04-1985');
UPDATE eqdatabase
set Date=replace(Date,'2011-03-13','13-03-2011');

UPDATE eqdatabase
SET Date2= str_to_date(`Date`,'%d-%m-%Y');

-- STANDARDIZE TIME FORMAT--
ALTER TABLE eqdatabase
ADD COLUMN Time2 time after Time;

UPDATE eqdatabase
set Time2=cast(Time as time);

select max(length(time))
from eqdatabase;

select min(length(time))
from eqdatabase;

select time
from eqdatabase
where length(time) = 24;

UPDATE eqdatabase
set time=replace(time,'1975-02-23T02:58:41.000Z',substr(time,12,8))
where time='1975-02-23T02:58:41.000Z';

UPDATE eqdatabase
set time=replace(time,'1985-04-28T02:53:41.530Z',substr(time,12,8))
where time='1985-04-28T02:53:41.530Z';

UPDATE eqdatabase
set time=replace(time,'2011-03-13T02:23:34.520Z',substr(time,12,8))
where time='2011-03-13T02:23:34.520Z';

UPDATE eqdatabase
set Time2=cast(Time as time);

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
set `Depth error`= CASE WHEN `Depth error` ='' THEN 0.0
						ELSE `Depth error`
                        END;
                        
UPDATE eqdatabase
set `Depth Seismic Stations`= CASE WHEN `Depth Seismic Stations` ='' THEN 0.0
						ELSE `Depth Seismic Stations`
                        END;
                       
UPDATE eqdatabase                     
set `Magnitude Error`= CASE WHEN `Magnitude Error` ='' THEN 0.0
						ELSE `Magnitude Error`
                        END;
                        
UPDATE eqdatabase                     
set `Magnitude Seismic Stations`= CASE WHEN `Magnitude Seismic Stations` ='' THEN 0.0
						ELSE `Magnitude Seismic Stations`
                        END;

UPDATE eqdatabase                     
set `Azimuthal Gap`= CASE WHEN `Azimuthal Gap` ='' THEN 0.0
						ELSE `Azimuthal Gap`
                        END;

UPDATE eqdatabase                     
set `Horizontal Distance`= CASE WHEN `Horizontal Distance` ='' THEN 0.0
						ELSE `Horizontal Distance`
                        END;
                        
UPDATE eqdatabase                     
set `Horizontal Error`= CASE WHEN `Horizontal Error` ='' THEN 0.0
						ELSE `Horizontal Error`
                        END;
                        
UPDATE eqdatabase                     
set `Root Mean Square`= CASE WHEN `Root Mean Square` ='' THEN 0.0
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
with t1 as 
(SELECT *, row_number() over(partition by Date2,Time2,Latitude,Longitude order by id) as rownum
FROM eqdatabase)
select count(*) from t1 where rownum>1

-- TO EXTRACT YEAR , MONTH AND DAY FROM Date column
-- EXTRACT YEAR--
SELECT EXTRACT(Year FROM Date2) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN Year int after Time2;

UPDATE eqdatabase
set Year= EXTRACT(Year FROM Date2);

-- EXTRACT MONTH--
SELECT EXTRACT(Month FROM Date2) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN Month int after Year;

UPDATE eqdatabase
set Month= EXTRACT(Month FROM Date2);

-- EXTRACT WEEK--
SELECT WEEK(DATE2,0) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN WEEK int after MONTH;

UPDATE eqdatabase
set Week= WEEK(DATE2,0);

ALTER TABLE eqdatabase
RENAME COLUMN WEEK TO Week;

-- Extract dayname
SELECT dayname(DATE2) from eqdatabase;

ALTER TABLE eqdatabase
ADD COLUMN `Day name` character after Week;

UPDATE eqdatabase
set `Day name`= dayname(DATE2);

ALTER TABLE eqdatabase
modify COLUMN `Day name` character(15) after Week;

UPDATE eqdatabase
set `Day name`= dayname(DATE2);

-- check for outliers--
select * from eqdatabase where Magnitude < 5.5;
select * from eqdatabase where Year > 2016 or Year < 1965;

-- drop the unnecesaary columns--
ALTER TABLE eqdatabase
DROP COLUMN Date,
DROP COLUMN Time;

-- RENAME DATE2 TO DATE AND TIME2 TO TIME
ALTER TABLE eqdatabase
RENAME COLUMN Date2 to Date,
RENAME COLUMN Time2 to Time;