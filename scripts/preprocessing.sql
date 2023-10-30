/*
 * preprocess data
 * */
use bellabeat_db;

/* * choose daily_activity, heartrate_second, hour_activity,
 minute_sleep, minute_METs_Narrow, sleep_day */

/*
 * *************************************************************************************************** *
 * ******************************** Check and remove unwanted observation **************************** *
 * *************************************************************************************************** *
 */ 

--  get some value (5) in daily_activity 
 select *
 from daily_activity 
 limit 5;

-- get some value (5) in heartrate_seconds
select * 
from heartrate_seconds 
limit 5; 

-- get some value (5) in hour_activity 
select * 
from hour_activity 
limit 5;

-- get some value (5) in minute_sleep 
select *
from minute_sleep 
limit 5; 

--  get some value (5) in minute_Mets_Narrow
select *
from minute_Mets_Narrow 
limit 5;
 
-- get some value (5) in sleep_day
select *
from sleep_day 
limit 5;

/*
 * *************************************************************************************************** *
 * ************************************ Check and remove inconsistent ******************************** *
 * *************************************************************************************************** *
 */

-- For daily_activity
-- Remove duplicated (check)

select '# total' as type_of_count, count(*) as value 
from daily_activity as da
union
select '# total distinct' as type_of_count, count(*) as value
from (
	select distinct *
	from daily_activity
	) as da_distinct;

-- create table temp as
-- select distinct *
-- from daily_activity da;
-- 
-- drop table daily_activity;
-- 
-- alter table temp rename daily_activity;

-- For heartrate_seconds
-- Remove duplicated (check)
select '#total' as type_of_count, count(*) as value
from heartrate_seconds as hs 
union 
select '#total distinct' as type_of_count, count(*) as value 
from (
	select distinct *
	from heartrate_seconds 
	) as hs_distinct;


-- For each numberic attribute remove inconsistency value (negative)
select 
from 


/*
 * *************************************************************************************************** *
 * ******************************************* Deal with outlier ************************************* *
 * *************************************************************************************************** *
 */

-- For daily_activity
-- Detect outlier



/*
 * *************************************************************************************************** *
 * ************************************ Check and deal with missing -********************************* *
 * *************************************************************************************************** *
 */
-- For daily_activity
-- 

/*
 * *************************************************************************************************** *
 * ***************************************** Data normalization ************************************** *
 * *************************************************************************************************** *
 */

/*
 * *************************************************************************************************** *
 * ************************************ Check and remove inconsistent ******************************** *
 * *************************************************************************************************** *
 */


/*
 * *************************************************************************************************** *
 * *********************************** Verify and data structure ************************************* *
 * *************************************************************************************************** *
 */

