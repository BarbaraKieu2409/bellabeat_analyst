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

-- For hour_activity 
-- Remove duplicated (check)
select '#total' as type_of_count, count(*) as value 
from hour_activity as ha
union 
select '#total distinct' as type_of_count, count(*) as value 
from (
	select distinct *
	from hour_activity
	) as ha_distinct;

-- for minute_sleep
-- Remove duplicated (check)
select '#total' as type_of_count, count(*) as value 
from minute_sleep as ms 
union 
select '#total distinct' as type_of_count, count(*) as value 
from (
	select distinct *
	from minute_sleep 
	) as ms_distinct;

create table temp as
select distinct *
from minute_sleep ms;
drop table minute_sleep;
alter table temp rename minute_sleep;

--  for minute_Mets_Narrow
-- Remove duplicated (check)
select '#total' as type_of_count, count(*) as value 
from minute_Mets_Narrow  as mmn
union 
select '#total distinct' as type_of_count, count(*) as value 
from (
	select distinct *
	from minute_Mets_Narrow  
	) as mmn_distinct;

-- for sleep day 
-- remove duplicated (check)
select '#total' as type_of_count, count(*) as value 
from sleep_day  as sd
union 
select '#total distinct' as type_of_count, count(*) as value 
from (
	select distinct *
	from sleep_day  
	) as sd_distinct;

create table temp as 
select distinct *
from sleep_day sd;
drop table sleep_day;
alter table temp rename sleep_day

-- For each numberic attribute remove inconsistency value (negative)
-- For daily_activity
select count(*) as total_inconsistency_value_per_num_attr
from daily_activity da 
where 
	TotalSteps < 0
	or
	TotalDistance < 0
	or
	TrackerDistance < 0
	or 
	LoggedActivitiesDistance < 0
	or 
	VeryActiveDistance < 0
	or 
	ModeratelyActiveDistance < 0
	or 
	LightActiveDistance < 0
	or 
	SedentaryActiveDistance < 0
	or 
	VeryActiveMinutes  < 0
	or 
	FairlyActiveMinutes < 0
	or 
	LightlyActiveMinutes < 0
	or 
	SedentaryMinutes < 0
	or 
	Calories < 0;

-- for heartrate_seconds 
select count(*) as total_inconsistency_value_per_num_attr
from heartrate_seconds hs  
where 
value < 0;

-- for hour_activity 
select count(*) as total_inconsistency_value_per_num_attr 
from hour_activity ha 
where 
Calories < 0 
or 
StepTotal < 0
or 
TotalIntensity < 0
or 
AverageIntensity < 0;

-- for minute_sleep
select count(*) as total_inconsistency_value_per_num_attr 
from minute_sleep ms  
where 
value < 0
or 
logId < 0;

--  for minute_Mets_Narrow
select count(*) as total_inconsistency_value_per_num_attr
from minute_Mets_Narrow mmn 
where 
Mets < 0;

-- for sleep_day
select count(*) as total_inconsitency_value_per_num_attr
from sleep_day sd 
where 
TotalSleepRecords < 0
or 
TotalMinutesAsleep < 0
or 
TotalTimeInBed < 0;


/*
 * *************************************************************************************************** *
 * ******************************************* Deal with outlier ************************************* *
 * *************************************************************************************************** *
 */

-- For daily_activity
-- Detect and remove outlier

select
	*
from
	(
	with daily_activity_stats as (
	select 
			avg(TotalSteps) as TotalSteps_mean,
			stddev(TotalSteps) as TotalSteps_std,
			avg(TotalDistance) as TotalDistance_mean,
			stddev(TotalDistance) as TotalDistance_std,
			avg(TrackerDistance) as TrackerDistance_mean, 
			stddev(TrackerDistance) as TrackerDistance_std,
			avg(LoggedActivitiesDistance) as LoggedActivitiesDistance_mean,
			stddev(LoggedActivitiesDistance) as LoggedActivitiesDistance_std,
			avg(VeryActiveDistance) as VeryActiveDistance_mean,
			stddev(VeryActiveDistance) as VeryActiveDistance_std,
			avg(ModeratelyActiveDistance) as ModeratelyActiveDistance_mean,
			stddev(ModeratelyActiveDistance) as ModeratelyActiveDistance_std,
			avg(LightActiveDistance) as LightActiveDistance_mean,
			stddev(LightActiveDistance) as LightActiveDistance_std,
			avg(SedentaryActiveDistance) as SedentaryActiveDistance_mean,
			stddev(SedentaryActiveDistance) as SedentaryActiveDistance_std,
			avg(VeryActiveMinutes) as VeryActiveMinutes_mean,
			stddev(VeryActiveMinutes) as VeryActiveMinutes_std,
			avg(FairlyActiveMinutes) as FairlyActiveMinutes_mean,
			stddev(FairlyActiveMinutes) as FairlyActiveMinutes_std,
			avg(LightlyActiveMinutes) as LightlyActiveMinutes_mean,
			stddev(LightlyActiveMinutes) as LightlyActiveMinutes_std,
			avg(SedentaryMinutes) as SedentaryMinutes_mean,
			stddev(SedentaryMinutes) as SedentaryMinutes_std,
			avg(Calories) as Calories_mean,
			stddev(Calories) as Calories_std
	from
		daily_activity
	)
	select
		Id,
		ActivityDate,
		abs(TotalSteps - da_stats.TotalSteps_mean) / da_stats.TotalSteps_std as TotalSteps_z_score,
		abs(TotalDistance - da_stats.TotalDistance_mean) / da_stats.TotalDistance_std as TotalDistance_z_score,
		abs(TrackerDistance - da_stats.TrackerDistance_mean) / da_stats.TrackerDistance_std as TrackerDistance_z_score,
		abs(LoggedActivitiesDistance - da_stats.LoggedActivitiesDistance_mean) / da_stats.LoggedActivitiesDistance_std as LoggedActivitiesDistance_z_score,
		abs(VeryActiveDistance - da_stats.VeryActiveDistance_mean) / da_stats.VeryActiveDistance_std as VeryActiveDistance_z_score,
		abs(ModeratelyActiveDistance - da_stats.ModeratelyActiveDistance_mean) / da_stats.ModeratelyActiveDistance_std as ModeratelyActiveDistance_z_score,
		abs(LightActiveDistance - da_stats.LightActiveDistance_mean) / da_stats.LightActiveDistance_std as LightActiveDistance_z_score,
		abs(SedentaryActiveDistance - da_stats.SedentaryActiveDistance_mean) / da_stats.SedentaryActiveDistance_std as SedentaryActiveDistance_z_score,
		abs(VeryActiveMinutes - da_stats.VeryActiveMinutes_mean) / da_stats.VeryActiveMinutes_std as VeryActiveMinutes_z_score,
		abs(FairlyActiveMinutes - da_stats.FairlyActiveMinutes_mean) / da_stats.FairlyActiveMinutes_std as FairlyActiveMinutes_z_score,
		abs(LightlyActiveMinutes - da_stats.LightlyActiveMinutes_mean) / da_stats.LightlyActiveMinutes_std as LightlyActiveMinutes_z_score,
		abs(SedentaryMinutes - da_stats.SedentaryMinutes_mean) / da_stats.SedentaryMinutes_std as SedentaryMinutes_z_score,
		abs(Calories - da_stats.Calories_mean) / da_stats.Calories_std as Calories_z_score
	from
		daily_activity,
		daily_activity_stats as da_stats
	) z_score_res
where 
		TotalSteps_z_score > 3
	or
		TotalDistance_z_score > 3
	or 
		TrackerDistance_z_score > 3
	or 
		LoggedActivitiesDistance_z_score > 3
	or 
		VeryActiveDistance_z_score > 3
	or 
		ModeratelyActiveDistance_z_score > 3
	or 
		LightActiveDistance_z_score > 3
	or 
		SedentaryActiveDistance_z_score > 3
	or 
		VeryActiveMinutes_z_score > 3
	or 
		FairlyActiveMinutes_z_score > 3
	or 
		LightlyActiveMinutes_z_score > 3
	or 
		SedentaryMinutes_z_score > 3
	or 
		Calories_z_score > 3;
		
	
-- 	for heartrate_seconds 
	select *
	from (
		with 
			Value_stats as (
			select 
				avg(Value) as mean,
				stddev(Value) as std
			from heartrate_seconds)
		select
			Id,
			'Time',
			abs(Value-va.mean) / va.std as Value_z_score
		from 
			Value_stats va,
			heartrate_seconds) z_score_res
	where 
		Value_z_score > 3;    

	
-- for hour_activity
	select *
	from ( 
		with 
			Calories_stats as (
			select 
				avg(Calories) as mean,
				stddev(Calories) as std 
			from hour_activity),
			StepTotal_stats as ( 
			select 
				avg(StepTotal) as mean,
				stddev(StepTotal) as std
			from hour_activity),
			TotalIntensity_stats as (
			select 
				avg(TotalIntensity) as mean, 
				stddev(TotalIntensity) as std
			from hour_activity),
			AverageIntensity_stats as (
			select 
				avg(AverageIntensity) as mean, 
				stddev(AverageIntensity) as std 
			from hour_activity) 
		select 
			Id, 
			ActivityHour,
			abs(Calories-ca.mean) / ca.std as Calories_z_score,
			abs(StepTotal-st.mean) / st.std as StepTotal_z_score,
			abs(TotalIntensity-ti.mean) / ti.std as TotalIntensity_z_score,
			abs(AverageIntensity-ai.mean)/ ai.std as AverageIntensity_z_score
		from 
			Calories_stats ca,
			StepTotal_stats st,
			TotalIntensity_stats ti,
			AverageIntensity_stats ai,
			hour_activity) z_score_res
	where 
			Calories_z_score > 3
			or 
			StepTotal_z_score > 3
			or
			TotalIntensity_z_score > 3
			or
			AverageIntensity_z_score > 3;
	
-- for minute_sleep
	select *
	from (
		with 
			Value_stats as (
			select 
				avg(Value) as mean,
				stddev(Value) as std
			from minute_sleep),
			logId_stats as (
			select 
				avg(logId) as mean, 
				stddev(logId) as std
			from minute_sleep) 
		select 
			Id, 
			'date', 
			abs(value-va.mean) / va.std as value_z_score,
			abs(logId-li.mean) / li.std as logId_z_score
		from 
			Value_stats va, 
			logId_stats li,
			minute_sleep) z_score_res
    where 
	    	value_z_score > 3
	    	or
	    	logId_z_score > 3;
	    
-- 	for Mets_Narrow
create table minute_Mets_Narrow_z_score(
	with 
		METs_stats as (
		select
			avg(METs) as mean,
			stddev(METs) as std
		from
			minute_Mets_Narrow)
	select
		Id,
		ActivityMinute,
		abs(METS-mt.mean) / mt.std METs_z_score
	from
		METs_stats mt,
		minute_Mets_Narrow;

update minute_Mets_Narrow as mMN join minute_Mets_Narrow_z_score as mMN_z on mMN.Id = mMN_z.Id and mMN.ActivityMinute = mMN_z.ActivityMinute
set METS = (
	select max(METS)
	from minute_Mets_Narrow_z_score
	where METs_z_score <= 3
	)
where METs_z_score > 3;

drop table minute_Mets_Narrow_z_score;
	   
-- 	for sleep_day
create table outlier as (
	with 
		TotalSleepRecords_stats as (  
		select 
			avg(TotalSleepRecords) as mean, 
			stddev(TotalSleepRecords) as std 
		from sleep_day), 
		TotalMinutesAsleep_stats as (
		select 
			avg(TotalMinutesAsleep) as mean,
			stddev(TotalMinutesAsleep) as std
		from sleep_day),
		TotalTimeInBed_stats as (
		select 
			avg(TotalTimeInBed) as mean, 
			stddev(TotalTimeInBed) as std 
		from sleep_day)
	select 
		sleep_day.*, 
		abs(TotalSleepRecords-tsr.mean) / tsr.std TotalSleepRecords_z_score,
		abs(TotalMinutesAsleep-tmas.mean) / tmas.std TotalMinutesAslepe_z_score, 
		abs(TotalTimeInBed-ttib.mean) / ttib.std TotalTimeInBed_z_score 
	from 
		TotalSleepRecords_stats tsr,
		TotalMinutesAsleep_stats tmas, 
		TotalTimeInBed_stats ttib,
		sleep_day);

	select * from outlier limit 19;
   
update sleep_day join outlier on sleep_day.Id = outlier.Id and sleep_day.SleepDay = outlier.SleepDay
set sleep_day.TotalSleepRecords = (
	select max(TotalSleepRecords)
	from outlier
	where 
		TotalSleepRecords_z_score <= 3)
where TotalSleepRecords_z_score > 3;


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
 * *********************************** Verify and data structure ************************************* *
 * *************************************************************************************************** *
 */

