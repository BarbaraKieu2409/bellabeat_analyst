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
create table daily_activity_z_score as (
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
		daily_activity.*,
		abs(TotalSteps - da_stats.TotalSteps_mean) / da_stats.TotalSteps_std as TotalSteps_z_score,
		abs(TotalDistance - da_stats.TotalDistance_mean) / da_stats.TotalDistance_std as TotalDistance_z_score,
		abs(TrackerDistance - da_stats.TrackerDistance_mean) / da_stats.TrackerDistance_std as TrackerDistance_z_score,
		abs(LoggedActivitiesDistance - da_stats.LoggedActivitiesDistance_mean) / da_stats.LoggedActivitiesDistance_std as LoggedActivitiesDistance_z_score,
		abs(VeryActiveDistance - da_stats.VeryActiveDistance_mean) / da_stats.VeryActiveDistance_std as VeryActiveDistance_z_score,
		abs(ModeratelyActiveDistance - da_stats.ModeratelyActiveDistance_mean) / da_stats.ModeratelyActiveDistance_std as ModeratelyActiveDistance_z_score,
		abs(LightActiveDistance - da_stats.LightActiveDistance_mean) / da_stats.LightActiveDistance_std as LightActiveDistance_z_score,
		abs(VeryActiveMinutes - da_stats.VeryActiveMinutes_mean) / da_stats.VeryActiveMinutes_std as VeryActiveMinutes_z_score,
		abs(FairlyActiveMinutes - da_stats.FairlyActiveMinutes_mean) / da_stats.FairlyActiveMinutes_std as FairlyActiveMinutes_z_score,
		abs(LightlyActiveMinutes - da_stats.LightlyActiveMinutes_mean) / da_stats.LightlyActiveMinutes_std as LightlyActiveMinutes_z_score,
		abs(SedentaryMinutes - da_stats.SedentaryMinutes_mean) / da_stats.SedentaryMinutes_std as SedentaryMinutes_z_score,
		abs(Calories - da_stats.Calories_mean) / da_stats.Calories_std as Calories_z_score
	from
		daily_activity,
		daily_activity_stats as da_stats
	); 

-- For TotalSteps column
-- get max TotalSteps when TotalSteps_z_score <= 3
select @max_TotalSteps:=max(TotalSteps)
From daily_activity_z_score 
where TotalSteps_z_score <=3;

-- replace all TotalSteps with @max_TotalSteps
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.TotalSteps = @max_TotalSteps
where da_z.TotalSteps_z_score > 3;		
	
-- For TotalDistance
-- get max TotalDistance when TotalDistance_z_score <= 3
select @max_TotalDistance:=max(TotalDistance)
From daily_activity_z_score 
where TotalDistance_z_score <=3;

-- replace all TotalDistance with @max_TotalDistance
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.TotalDistance = @max_TotalDistance
where da_z.TotalDistance_z_score > 3;	

-- For TrackerDistance
-- get max TrackerDistance when TrackerDistance_z_score <= 3
select @max_TrackerDistance:=max(TrackerDistance)
From daily_activity_z_score 
where TrackerDistance_z_score <=3;

-- replace all TrackerDistance with @max_TrackerDistance
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.TrackerDistance = @max_TrackerDistance
where da_z.TrackerDistance_z_score > 3;	

-- For LoggedActivitiesDistance
-- get max LoggedActivitiesDistance when LoggedActivitiesDistance_z_score <= 3
select @max_LoggedActivitiesDistance:=max(LoggedActivitiesDistance)
From daily_activity_z_score 
where LoggedActivitiesDistance_z_score <=3;

-- replace all LoggedActivitiesDistance with @max_LoggedActivitiesDistance
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.LoggedActivitiesDistance = @max_LoggedActivitiesDistance
where da_z.LoggedActivitiesDistance_z_score > 3;	

-- For VeryActiveDistance
-- get max VeryActiveDistance when VeryActiveDistance_z_score <= 3
select @max_VeryActiveDistance:=max(VeryActiveDistance)
From daily_activity_z_score 
where VeryActiveDistance_z_score <=3;

-- replace all VeryActiveDistance with @max_VeryActiveDistance
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.VeryActiveDistance = @max_VeryActiveDistance
where da_z.VeryActiveDistance_z_score > 3;

-- For ModeratelyActiveDistance
-- get max ModeratelyActiveDistance when ModeratelyActiveDistance_z_score <= 3
select @max_ModeratelyActiveDistance:=max(ModeratelyActiveDistance)
From daily_activity_z_score 
where ModeratelyActiveDistance_z_score <=3;

-- replace all ModeratelyActiveDistance with @max_ModeratelyActiveDistance
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.ModeratelyActiveDistance = @max_ModeratelyActiveDistance
where da_z.ModeratelyActiveDistance_z_score > 3;

-- For LightActiveDistance column
-- get max LightActiveDistance when LightActiveDistance_z_score <= 3
select @max_LightActiveDistance:=max(LightActiveDistance)
From daily_activity_z_score 
where LightActiveDistance_z_score <=3;

-- replace all LightActiveDistance with @max_LightActiveDistance
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.LightActiveDistance = @max_LightActiveDistance
where da_z.LightActiveDistance_z_score > 3;

-- For SedentaryActiveDistance (all value are zero)

-- For VeryActiveMinutes column
-- get max VeryActiveMinutes when VeryActiveMinutes_z_score <= 3
select @max_VeryActiveMinutes:=max(VeryActiveMinutes)
From daily_activity_z_score 
where VeryActiveMinutes_z_score <=3;

-- replace all VeryActiveMinutes with @max_VeryActiveMinutes
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.VeryActiveMinutes = @max_VeryActiveMinutes
where da_z.VeryActiveMinutes_z_score > 3;

-- For FairlyActiveMinutes column
-- get max FairlyActiveMinutes when FairlyActiveMinutes_z_score <= 3
select @max_FairlyActiveMinutes:=max(FairlyActiveMinutes)
From daily_activity_z_score 
where FairlyActiveMinutes_z_score <=3;

-- replace all FairlyActiveMinutes with @max_FairlyActiveMinutes
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.FairlyActiveMinutes = @max_FairlyActiveMinutes
where da_z.FairlyActiveMinutes_z_score > 3;

-- For FairlyActiveMinutes
-- get max FairlyActiveMinutes when FairlyActiveMinutes_z_score <= 3
select @max_FairlyActiveMinutes:=max(FairlyActiveMinutes)
From daily_activity_z_score 
where FairlyActiveMinutes_z_score <=3;

-- replace all FairlyActiveMinutes with @max_FairlyActiveMinutes
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.FairlyActiveMinutes = @max_FairlyActiveMinutes
where da_z.FairlyActiveMinutes_z_score > 3;

-- For LightlyActiveMinutes column
-- get max LightlyActiveMinutes when LightlyActiveMinutes_z_score <= 3
select @max_LightlyActiveMinutes:=max(LightlyActiveMinutes)
From daily_activity_z_score 
where LightlyActiveMinutes_z_score <=3;

-- For LightlyActiveMinutes column
-- replace all LightlyActiveMinutes with @max_LightlyActiveMinutes
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.LightlyActiveMinutes = @max_LightlyActiveMinutes
where da_z.LightlyActiveMinutes_z_score > 3;

-- get max SedentaryMinutes when SedentaryMinutes_z_score <= 3
select @max_SedentaryMinutes:=max(SedentaryMinutes)
From daily_activity_z_score 
where SedentaryMinutes_z_score <=3;

-- replace all SedentaryMinutes with @max_SedentaryMinutes
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.SedentaryMinutes = @max_SedentaryMinutes
where da_z.SedentaryMinutes_z_score > 3;

-- For Calories column
-- get max Calories when Calories_z_score <= 3
select @max_Calories:=max(Calories)
From daily_activity_z_score 
where Calories_z_score <=3;

-- replace all Calories with @max_Calories
update daily_activity as da join daily_activity_z_score as da_z on da.Id = da_z.Id and da.ActivityDate = da_z.ActivityDate 
set da.Calories = @max_Calories
where da_z.Calories_z_score > 3;

-- drop daily_activity_z_score (temp)
drop table daily_activity_z_score;

-- 	for heartrate_seconds 
create table heartrate_seconds_z_score(
	with 
		Value_stats as (
		select 
			avg(Value) as mean,
			stddev(Value) as std
		from heartrate_seconds)
	select
		heartrate_seconds.*, 
		abs(Value-va.mean) / va.std as Value_z_score
	from 
		Value_stats va,
		heartrate_seconds);

-- For Value column
-- get max Value when Value_z_score <= 3
select @max_Value:=max(Value)
From heartrate_seconds_z_score 
where Value_z_score <=3;

-- replace all Value with @max_Value
update heartrate_seconds as hs join heartrate_seconds_z_score as hs_z on hs.Id = hs_z.Id and hs.Time = hs_z.Time
set hs.Value = @max_Value
where hs_z.Value_z_score > 3;

-- drop table heartrate_seconds_z_score (temp)
drop table heartrate_seconds_z_score;

-- -------------------------------------------------------------------------------------------------
-- for hour_activity
create table hour_activity_z_score(
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
		hour_activity.*,
		abs(Calories-ca.mean) / ca.std as Calories_z_score,
		abs(StepTotal-st.mean) / st.std as StepTotal_z_score,
		abs(TotalIntensity-ti.mean) / ti.std as TotalIntensity_z_score,
		abs(AverageIntensity-ai.mean)/ ai.std as AverageIntensity_z_score
	from 
		Calories_stats ca,
		StepTotal_stats st,
		TotalIntensity_stats ti,
		AverageIntensity_stats ai,
		hour_activity);
	
-- For Calories column
-- get max Calories when Calories_z_score <= 3
select @max_Calories:=max(Calories)
From hour_activity_z_score 
where Calories_z_score <=3;

-- replace all Calories with @max_Calories
update hour_activity as ha join hour_activity_z_score as ha_z on ha.Id = ha_z.Id and ha.ActivityHour = ha_z.ActivityHour
set ha.Calories = @max_Calories 
where ha_z.Calories_z_score > 3;

-- For StepTotal column
-- get max StepTotal when StepTotal_z_score <= 3
select @max_StepTotal:=max(StepTotal)
from hour_activity_z_score
where StepTotal_z_score <=3;

-- replace all StepTotal with @max_StepTotal 
update hour_activity as ha join hour_activity_z_score as ha_z on ha.Id = ha_z.Id and ha.ActivityHour = ha_z.ActivityHour
set ha.StepTotal = @max_StepTotal 
where ha_z.StepTotal_z_score > 3 ; 

-- For TotalIntensity
-- get max TotalIntensity when TotalIntensity_z_score <=3
select @max_TotalIntensity:=max(TotalIntensity)
from hour_activity_z_score
where TotalIntensity_z_score <=3;

-- replace all TotalIntensity with @max_TotalIntensity
update hour_activity as ha join hour_activity_z_score as ha_z on ha.Id = ha_z.Id and ha.ActivityHour = ha_z.ActivityHour
set ha.TotalIntensity = @max_TotalIntensity
where ha_z.TotalIntensity_z_score > 3 ;

-- For AverageIntensity column
-- get max AverageIntensity when AverageIntensity_z_score <=3
select @max_AverageIntensity:=max(AverageIntensity)
from hour_activity_z_score
where AverageIntensity_z_score <=3;

-- replace all AverageIntensity with @max_AverageIntensity
update hour_activity as ha join hour_activity_z_score as ha_z on ha.Id = ha_z.Id and ha.ActivityHour = ha_z.ActivityHour
set ha.AverageIntensity = @max_AverageIntensity
where ha_z.AverageIntensity_z_score > 3 ;

-- drop table hour_activity_z_score (temp)
drop table hour_activity_z_score;

-- -------------------------------------------------------------------------------------------------
-- for minute_sleep
create table minute_sleep_z_score(
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
		minute_sleep.*,
		abs(value-va.mean) / va.std as value_z_score,
		abs(logId-li.mean) / li.std as logId_z_score
	from 
		Value_stats va, 
		logId_stats li,
		minute_sleep);
		
-- For value column
-- get max value when value_z_score <= 3
select @max_value:=max(value)
from minute_sleep_z_score
where value_z_score <=3;

-- replace all value with @max_value
update minute_sleep as ms join minute_sleep_z_score as ms_z on ms.Id = ms_z.Id and ms.date = ms_z.date
set ms.value = @max_value
where ms_z.value_z_score > 3;
 
-- -------------------------------------------------------------------------------------------------
-- 	for minute_Mets_Narrow
create table minute_Mets_Narrow_z_score(
	with 
		METs_stats as (
		select
			avg(METs) as mean,
			stddev(METs) as std
		from
			minute_Mets_Narrow)
	select
		minute_Mets_Narrow.*,
		abs(METs-mt.mean) / mt.std METs_z_score
	from
		METs_stats mt,
		minute_Mets_Narrow);

-- for METs column
-- get max METs when METs_z_score <= 3
select @max_METs:=max(METs)
from minute_Mets_Narrow_z_score
where METs_z_score <= 3;

-- replace all METs with @max_METs
update minute_Mets_Narrows as mMN join minute_Mets_Narrow_z_score as mMN_z on mMN.Id = mMN_z.Id and mMN.ActivityMinute = mMN_z.ActivityMinute
set mMN.METs = @max_METs
where mMN_z.METs_z_score > 3;

-- drop table minute_Mets_Narrow_z_score (temp)
drop table minute_Mets_Narrow_z_score;

-- -------------------------------------------------------------------------------------------------
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
		abs(TotalMinutesAsleep-tmas.mean) / tmas.std TotalMinutesAsleep_z_score, 
		abs(TotalTimeInBed-ttib.mean) / ttib.std TotalTimeInBed_z_score 
	from 
		TotalSleepRecords_stats tsr,
		TotalMinutesAsleep_stats tmas, 
		TotalTimeInBed_stats ttib,
		sleep_day);
 
-- for TotalSleepRecords column
update sleep_day join outlier on sleep_day.Id = outlier.Id and sleep_day.SleepDay = outlier.SleepDay
set sleep_day.TotalSleepRecords = (
	select max(TotalSleepRecords)
	from outlier
	where 
		TotalSleepRecords_z_score <= 3)
where TotalSleepRecords_z_score > 3;

update sleep_day join outlier on sleep_day.Id = outlier.Id and sleep_day.SleepDay = outlier.SleepDay 
set sleep_day.TotalMinutesAsleep = ( 
	select max(TotalMinutesAsleep)
	from outlier 
	where 
		TotalMinutesAsleep_z_score <= 3) 
where TotalMinutesAsleep_z_score > 3; 

-- for TotalTimeInBed column
update sleep_day join outlier on sleep_day.Id = outlier.Id and sleep_day.sleepDay = outlier.SleepDay
set sleep_day.TotalTimeInBed = ( 
	select max(TotalTimeInBed)
	from outlier 
	where 
		TotalTimeInBed_z_score <=3) 
where TotalTimeInBed_z_score >3;

-- drop table outlier (temp)
drop table outlier;

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

