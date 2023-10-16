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

-- get column name in dailyActivity_merged
select COLUMN_NAME, DATA_TYPE 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = N'dailyActivity_merged';

-- get column name in dailyCalories_merged
select COLUMN_NAME, DATA_TYPE 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = N'dailyCalories_merged';