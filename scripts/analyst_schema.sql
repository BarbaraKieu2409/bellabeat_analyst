/*
 * explore data
 * */
use bellabeat_db;

-- get all table_name in this database 
select table_name
from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'bellabeat_db';

-- reanalyze for each table 
analyze table dailyActivity_merged;
analyze table dailyCalories_merged;
analyze table dailyIntensities_merged;
analyze table dailySteps_merged;
analyze table heartrate_seconds_merged;
analyze table hourlyCalories_merged;
analyze table hourlyIntensities_merged;
analyze table hourlySteps_merged;
analyze table minuteCaloriesNarrow_merged;
analyze table minuteCaloriesWide_merged;
analyze table minuteIntensitiesNarrow_merged;
analyze table minuteIntensitiesWide_merged;
analyze table minuteMETsNarrow_merged;
analyze table minuteSleep_merged;
analyze table minuteStepsNarrow_merged;
analyze table minuteStepsWide_merged;
analyze table sleepDay_merged;
analyze table weightLogInfo_merged;

-- get table name and totol row 
select TABLE_NAME, TABLE_ROWS as TOTAL_ROW
from INFORMATION_SCHEMA.TABLES
where TABLE_SCHEMA = 'bellabeat_db';

-- get some values (5) in dailyActivity_merged table
select * 
from dailyActivity_merged
limit 5;

-- get some values (5) in dailyCalories_merged
select * 
from dailyCalories_merged
limit 5;

-- get some values (5) in dailyIntensities_merged
select *
from dailyIntensities_merged
limit 5;

-- get some values (5) in dailySteps_merged
select *
from dailySteps_merged 
limit 5;

-- get some values (5) in heartrate_seconds_merged
select *
from heartrate_seconds_merged
limit 5;

-- get some values (5) hourlyCalories_merged
select *
from hourlyCalories_merged
limit 5;

-- get some values (5) in hourlyIntensities_merged
select *
from hourlyIntensities_merged
limit 5;

-- get some values (5) in hourlySteps_merged
select *
from hourlySteps_merged 
limit 5;

-- get some values (5) in  minuteCaloriesNarrow_merged
select *
from minuteCaloriesNarrow_merged
limit 5;

-- get some values (5) in  minuteCaloriesWide_merged
select *
from minuteCaloriesWide_merged 
limit 5;

-- get some values (5) in  minuteIntensitiesNarrow_merged 
select *
from minuteIntensitiesNarrow_merged
limit 5;

-- get some values (5) in  minuteIntensitiesWide_merged
select *
from minuteIntensitiesWide_merged
limit 5;

-- get some values (5) in  minuteMETsNarrow_merged
select *
from minuteMETsNarrow_merged 
limit 5;

-- get some values (5) in  minuteSleep_merged
select *
from minuteSleep_merged
limit 5;

-- get some values (5) in  minuteStepsNarrow_merged
select *
from minuteStepsNarrow_merged
limit 5;

-- get some values (5) in  minuteStepsWide_merged
select *
from minuteStepsWide_merged
limit 5;

-- get some values (5) in  sleepDay_merged
select *
from sleepDay_merged 
limit 5;

-- get some values (5) in weightLogInfo_merged
select *
from weightLogInfo_merged
limit 5;


-- merged tables hour_activity ( data colection)
create table hour_activity as 
select *
from 
	hourlyCalories_merged as calories
	join 
	hourlySteps_merged as steps
	using (Id, ActivityHour)
	join hourlyIntensities_merged as Intensities
	using (Id, ActivityHour)
;

-- rename
alter table dailyActivity_merged  rename daily_activity;
alter table heartrate_seconds_merged rename heartrate_seconds;
alter table minuteSleep_merged rename minute_sleep;
alter table minuteMETsNarrow_merged rename minute_Mets_Narrow;
alter table sleepDay_merged rename sleep_day;

/* choose daily_activity, heartrate_second, hour_activity,
 minute_sleep, minute_METs_Narrow, sleep_day */

-- create indexes for all table which chossing. Indexes for optimize performence
create index daily_activity_index on daily_activity (Id, ActivityDate);
create index heartrate_seconds_index on heartrate_seconds (Id, Time);
create index hour_activity_index on hour_activity (Id, ActivityHour);
create index minute_sleep_index on minute_sleep (Id, date);
create index minute_Mets_Narrow_index on minute_Mets_Narrow (Id, ActivityMinute);
create index sleep_day_index on sleep_day (Id, SleepDay);
