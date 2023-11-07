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

-- -------------------------------------------------------------------------------------------------
-- get some value (5) in heartrate_seconds
select * 
from heartrate_seconds 
limit 5; 

-- -------------------------------------------------------------------------------------------------
-- get some value (5) in hour_activity 
select * 
from hour_activity 
limit 5

-- -------------------------------------------------------------------------------------------------
-- get some value (5) in minute_sleep 
select *
from minute_sleep 
limit 5; 

-- -------------------------------------------------------------------------------------------------
--  get some value (5) in minute_Mets_Narrow
select *
from minute_Mets_Narrow 
limit 5;
 
-- -------------------------------------------------------------------------------------------------
-- get some value (5) in sleep_day
select *
from sleep_day 
limit 5;

-- -------------------------------------------------------------------------------------------------
-- get some value (5) in weight_log
select *
from weight_log
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

-- -------------------------------------------------------------------------------------------------
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

-- -------------------------------------------------------------------------------------------------
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

-- -------------------------------------------------------------------------------------------------
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

-- create table temp for store distinct row in table which you want remove duplicated rows
create table temp as
select distinct *
from minute_sleep ms;
-- remove old table (having dulicated rows)
drop table minute_sleep;
-- change temp to old table name
alter table temp rename minute_sleep;

-- -------------------------------------------------------------------------------------------------
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

-- -------------------------------------------------------------------------------------------------
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

-- -------------------------------------------------------------------------------------------------
-- for weight_log
select '#total' as type_of_count, count(*) as value 
from weight_log as wl
union 
select '#total distinct' as type_of_count, count(*) as value 
from (
	select distinct *
	from weight_log wl
	) as wl_distinct;

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

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

-- -------------------------------------------------------------------------------------------------
-- for heartrate_seconds 
select count(*) as total_inconsistency_value_per_num_attr
from heartrate_seconds hs  
where 
	value < 0;

-- -------------------------------------------------------------------------------------------------
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

-- -------------------------------------------------------------------------------------------------
-- for minute_sleep (value is category field)

-- -------------------------------------------------------------------------------------------------
--  for minute_Mets_Narrow
select count(*) as total_inconsistency_value_per_num_attr
from minute_Mets_Narrow mmn 
where 
	Mets < 0;

-- -------------------------------------------------------------------------------------------------
-- for sleep_day
select count(*) as total_inconsitency_value_per_num_attr
from sleep_day sd 
where 
	TotalSleepRecords < 0
	or 
	TotalMinutesAsleep < 0
	or 
	TotalTimeInBed < 0;

-- -------------------------------------------------------------------------------------------------
-- for weight_log
select count(*) as total_inconsitency_value_per_num_attr
from weight_log wl 
where 
	WeightKg != NULL and WeightKg <= 0
	or 
	WeightPounds != NULL and WeightPounds <= 0
	or
	Fat != NULL and Fat <= 0
	or 
	BMI != NULL and BMI <= 0;

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- Check TotalDistance = VeryActiveDistance + ModeratelyActiveDistance 
--                                          + LightActiveDistance 
--                                          + SedentaryActiveDistance ?

select 
	VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance + SedentaryActiveDistance as real_TotalDistance,
	TotalDistance,
	abs(VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance + SedentaryActiveDistance - TotalDistance) as TotalDistance_engagement
from daily_activity
where 
	VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance + SedentaryActiveDistance != TotalDistance;

-- fix TotalDistance
update daily_activity 
set TotalDistance = VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance + SedentaryActiveDistance
where VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance + SedentaryActiveDistance != TotalDistance;

-- check real_tracker_engagement_distance
set @threshold_real_tracker = 1.0;

select count(*) as total
from daily_activity
where abs(TotalDistance - TrackerDistance) > @threshold_real_tracker;
-- We have 52 data point which real_tracker_engagement > threshold_real_tracker
-- We do nothing because it can bring useful informations.

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- Check pounds * 0.45359237 = kg in weight log

set @pound_to_kg = 0.45359237

select 
	WeightKg,
	WeightPounds,
	abs(WeightKg - @pound_to_kg * WeightPounds)
from weight_log;

-- The result that WeightKg and WeightPounds can exchange to each other

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

-- For LoggedActivitiesDistance (almost value are zero - missing)

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

-- For SedentaryActiveDistance (almost value are zero)

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
-- this table only contain category field (value)


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

-- -------------------------------------------------------------------------------------------------
-- for weight_log
create table weight_log_z_score as (
	with 
		WeightKg_stats as (
			select
				avg(WeightKg) as mean,
				stddev(WeightKg) as std
			from weight_log
		),
		WeightPounds_stats as (
			select
				avg(WeightPounds) as mean,
				stddev(WeightPounds) as std
			from weight_log
		),
		BMI_stats as (
			select 
				avg(BMI) as mean,
				stddev(BMI) as std
			from weight_log
		)
	select 
		wl.*,
		abs(WeightKg - WeightKg_stats.mean) / WeightKg_stats.std as WeightKg_z_score,
		abs(WeightPounds - WeightPounds_stats.mean) / WeightPounds_stats.std as WeightPounds_z_score,
		abs(BMI - BMI_stats.mean) / BMI_stats.std as BMI_z_score
	from
		weight_log as wl,
		WeightKg_stats,
		WeightPounds_stats,
		BMI_stats
	where 
		ISNULL(WeightKg) = FALSE
		or
		ISNULL(WeightPounds) = FALSE 
		or 
		ISNULL(BMI) = FALSE);

-- for WeightKg column
-- get max WeightKg when WeightKg_z_score <= 3
select @max_WeightKg:=max(WeightKg)
from weight_log_z_score
where WeightKg_z_score <= 3;

-- replace all WeightKg with @max_WeightKg
update weight_log as wl join weight_log_z_score as wl_z on wl.Id = wl_z.Id and wl.Date = wl_z.Date
set wl.WeightKg = @max_WeightKg
where wl_z.WeightKg_z_score  > 3;

-- for WeightPounds column
-- get max WeightPounds when WeightPounds_z_score <= 3
select @max_WeightPounds:=max(WeightPounds)
from weight_log_z_score
where WeightPounds_z_score  <= 3;

-- replace all WeightPounds with @max_WeightPounds
update weight_log as wl join weight_log_z_score as wl_z on wl.Id = wl_z.Id and wl.Date = wl_z.Date
set wl.WeightPounds  = @max_WeightPounds
where wl_z.WeightPounds_z_score  > 3;

-- for BMI column
-- get max BMI when BMI_z_score <= 3
select @max_BMI:=max(BMI)
from weight_log_z_score
where BMI_z_score <= 3;

-- replace all BMI with @max_BMI
update weight_log as wl join weight_log_z_score as wl_z on wl.Id = wl_z.Id and wl.Date = wl_z.Date
set wl.BMI = @max_BMI
where wl_z.BMI_z_score > 3;

-- drop weight_log_z_score temp
drop table weight_log_z_score;

/*
 * *************************************************************************************************** *
 * ************************************ Check and deal with missing -********************************* *
 * *************************************************************************************************** *
 */
-- For daily_activity
-- detect missing (mising if value = NULL)

select 'TotalSteps' as column_name, count(*) as total_missing
from daily_activity
where isnull(TotalSteps) = TRUE 
union
select 'TotalDistance' as column_name, count(*) as total_missing
from daily_activity
where isnull(TotalDistance) = TRUE
union 
select 'TrackerDistance' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(TrackerDistance) = TRUE
union 
select 'LoggedActivitiesDistance' as column_name, count(*) as total_missing
from daily_activity 
where isnull(LoggedActivitiesDistance) = TRUE
union 
select 'VeryActiveDistance' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(VeryActiveDistance) = TRUE
union 
select 'ModeratelyActiveDistance' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(ModeratelyActiveDistance) = TRUE
union 
select 'LightActiveDistance' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(LightActiveDistance) = TRUE 
union 
select 'SedentaryActiveDistance' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(SedentaryActiveDistance) = TRUE
union 
select 'VeryActiveMinutes' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(VeryActiveMinutes) = TRUE
union 
select 'FairlyActiveMinutes' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(FairlyActiveMinutes) = TRUE
union 
select 'LightlyActiveMinutes' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(LightlyActiveMinutes) = TRUE
union 
select 'SedentaryMinutes' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(SedentaryMinutes) = TRUE
union 
select 'Calories' as column_name, count(*) as total_missing 
from daily_activity 
where isnull(Calories) = TRUE or Calories = 0;

-- -------------------------------------------------------------------------------------------------
-- For heartrate_seconds (hearate_second missing = NULL or zero)
-- detect missing (mising if value = NULL)
select 'Value' as column_name, count(*) as total_missing
from heartrate_seconds 
where isnull(Value) = TRUE or Value = 0;

-- -------------------------------------------------------------------------------------------------
-- for hour_activity 
-- detect missing (missing if value = NULL)
select 'Calories' as column_name, count(*) as total_missing
from hour_activity  
where isnull(Calories) = TRUE or Calories = 0
union 
select 'StepTotal' as column_name, count(*) as total_missing
from hour_activity  
where isnull(StepTotal) = TRUE
union 
select 'TotalIntensity' as column_name, count(*) as total_missing
from hour_activity  
where isnull(TotalIntensity) = TRUE
union 
select 'AverageIntensity' as column_name, count(*) as total_missing
from hour_activity  
where isnull(AverageIntensity) = TRUE;

-- -------------------------------------------------------------------------------------------------
-- for minute_sleep 
-- detect missing (missing if value = NULL)
select 'value' as column_name, count(*) as total_missing
from minute_sleep  
where isnull(value) = TRUE;

-- -------------------------------------------------------------------------------------------------
-- for minute_Mets_Narrow
-- detect missing (missing if value = NULL)
select 'METs' as column_name, count(*) as total_missing
from minute_Mets_Narrow  
where isnull(METs) = TRUE;

-- -------------------------------------------------------------------------------------------------
-- for sleep_day 
-- detect missing (missing if value = NULL)
select 'TotalSleepRecords' as column_name, count(*) as total_missing
from sleep_day  
where isnull(TotalSleepRecords) = TRUE
union 
select 'TotalMinutesAsleep' as column_name, count(*) as total_missing
from sleep_day  
where isnull(TotalMinutesAsleep) = TRUE
union 
select 'TotalTimeInBed ' as column_name, count(*) as total_missing
from sleep_day  
where isnull(TotalTimeInBed) = TRUE;

-- -------------------------------------------------------------------------------------------------
-- for sleep_day 
-- detect missing (missing if value = NULL or zero)
select 'WeightKg' as column_name, count(*) as total_missing
from weight_log
where isnull(WeightKg) = TRUE
union
select 'WeightPounds' as column_name, count(*) as total_missing
from weight_log
where isnull(WeightPounds) = TRUE
union
select 'Fat' as column_name, count(*) as total_missing
from weight_log
where isnull(Fat) = TRUE
union
select 'BMI' as column_name, count(*) as total_missing
from weight_log
where isnull(BMI) = TRUE;


-- Fat missing: 65/67 rows
-- What is the missing rate between manual measurement and direct measurement?
select IsManualReport, count(*) as total_missing
from weight_log
where isnull(Fat) = TRUE
group by IsManualReport
order by IsManualReport;
-- 39/26

-- we will do nothing because that missing is realistic and helpful

/*
 * *************************************************************************************************** *
 * ***************************************** Data normalization ************************************** *
 * *************************************************************************************************** *
 */

-- for daily_activity
-- check ActivityDate distinct
select distinct ActivityDate from daily_activity;

-- change type of ActivityDate from varchar(10) to date (rename by Date)
-- update ActivityDate value to format date ('%m/%d/%Y' -> '%Y-%m-%d')
update daily_activity
set ActivityDate = str_to_date(ActivityDate,'%m/%d/%Y');

-- change ActivityDate datatype
alter table daily_activity 
modify ActivityDate date; 

-- rename ActivityDate to Date
alter table daily_activity 
rename column ActivityDate to `Date`;

-- -------------------------------------------------------------------------------------------------
-- for hour_activity
select distinct ActivityHour from hour_activity;
-- split ActivityHour to Date (only contain date) and Time (only contain hh:mm:ss - 24)
-- add two empty columns (Date and Time with datatype is varchar(50))
alter table hour_activity
add column `Date` varchar(50) default '',
add column `Time` varchar(50) default '';

-- update Date value
update hour_activity
set `Date` = str_to_date(substring_index(ActivityHour, ' ', 1),'%m/%d/%Y');

-- update Time value
update hour_activity
set `Time` = str_to_date(substring_index(ActivityHour, ' ', -2), '%h:%i:%s %p');

-- change Date and Time datatype
alter table hour_activity
modify `Date` date,
modify `Time` time;

-- remove ActivityHour 
alter table hour_activity 
drop column ActivityHour;

-- -------------------------------------------------------------------------------------------------
-- for heartrate_seconds
select distinct `Time` from heartrate_seconds;
-- split Time to Date (only contain date) and Time (only contain hh:mm:ss - 24)
-- add column (Date) varchar(50)
alter table heartrate_seconds
add column `Date` varchar(50) default '';

-- update Date value
update heartrate_seconds 
set `Date` = str_to_date(substring_index(`Time`, ' ', 1),'%m/%d/%Y');

-- update Time value
update heartrate_seconds
set `Time` = str_to_date(substring_index(`Time`, ' ', -2), '%h:%i:%s %p');

-- update Date and Time datatypes
alter table heartrate_seconds 
modify `Date` date,
modify `Time` time;


-- -------------------------------------------------------------------------------------------------
-- for minute_sleep
select distinct `date` from minute_sleep;
-- split date to Date (only contain date) and Time (only contain hh:mm:ss - 24)
alter table minute_sleep 
add column `Time` varchar(50) default '',
rename column `date` to `Date`;

-- update Time value 
update minute_sleep 
set `Time` = str_to_date(substring_index(`Date`, ' ', -2), '%h:%i:%s %p');

-- update Date value 
update minute_sleep 
set `Date` = str_to_date(substring_index(`Date`, ' ', 1),'%m/%d/%Y');

-- update Date and Time datatypes 
alter table minute_sleep 
modify `Date` date, 
modify `Time` time;


select distinct value from minute_sleep;
-- we know "Value indicating the sleep state. 1 = asleep, 2 = restless, 3 = awake"
-- So we will transform it to string
alter table minute_sleep 
modify value varchar(8);

update minute_sleep 
set value = 'asleep'
where value = '1';

update minute_sleep 
set value = 'restless'
where value = '2';

update minute_sleep 
set value = 'awake'
where value = '3';


-- -------------------------------------------------------------------------------------------------
-- for minute_METs_Narrow
select distinct ActivityMinute from minute_Mets_Narrow;
-- split ActivityMinute to Date (only contain date) and Time (only contain hh:mm:ss - 24)
alter table minute_METs_Narrow
add column `Time` varchar(50) default '',
add column `Date` varchar(50) default '';

-- update Time value 
update minute_Mets_Narrow 
set `Time` = str_to_date(substring_index(`ActivityMinute`, ' ', -2), '%h:%i:%s %p');

-- update Date value 
update minute_Mets_Narrow
set `Date` = str_to_date(substring_index(ActivityMinute, ' ', 1),'%m/%d/%Y');

-- update Date and Time datatypes 
alter table minute_Mets_Narrow  
modify `Date` date, 
modify `Time` time;

-- remove ActivityMinute
alter table minute_Mets_Narrow 
drop column ActivityMinute;

-- -------------------------------------------------------------------------------------------------
-- for sleep_day
select distinct SleepDay from sleep_day;
-- split SleepDay to Date (only contain date) and Time (only contain hh:mm:ss - 24)
alter table sleep_day 
add column `Time` varchar(50) default '',
add column `Date` varchar(50) default '';

-- update Time value 
update sleep_day 
set `Time` = str_to_date(substring_index(`SleepDay`, ' ', -2), '%h:%i:%s %p');

-- update Date value 
update sleep_day 
set `Date` = str_to_date(substring_index(`SleepDay`, ' ', 1),'%m/%d/%Y');

-- update Date and Time datatypes 
alter table sleep_day 
modify `Date` date, 
modify `Time` time;

-- remove SleepDay
alter table sleep_day 
drop column SleepDay;


-- -------------------------------------------------------------------------------------------------
-- for weight_log
select distinct `Date` from weight_log;
-- split Date to Date (only contain date) and Time (only contain hh:mm:ss - 24)
alter table weight_log 
add column `Time` varchar(50) default '';

-- update Time value 
update weight_log 
set `Time` = str_to_date(substring_index(`Date`, ' ', -2), '%h:%i:%s %p');

-- update Date value 
update weight_log 
set `Date` = str_to_date(substring_index(`Date`, ' ', 1),'%m/%d/%Y');

-- update Date and Time datatypes 
alter table weight_log 
modify `Date` date, 
modify `Time` time;


/*
 * *************************************************************************************************** *
 * *********************************** Verify and data modeling ************************************** *
 * *************************************************************************************************** *
 */
-- select some value from daily_activity
select *
from daily_activity
limit 5;

-- show all indexes from daily_activity
show index from daily_activity;

-- -------------------------------------------------------------------------------------------------
-- select some value from heartrate_seconds 
select * 
from heartrate_seconds  
limit 5;

-- show all indexes from heartrate_seconds 
show index from heartrate_seconds;
alter table heartrate_seconds 
drop index heartrate_seconds_index, 
add index heartrate_seconds_index(Id, `Date`, `Time`);

-- -------------------------------------------------------------------------------------------------
-- select some value from hour_activity
select *
from hour_activity
limit 5;

-- show all indexes from hour_activity
show index from hour_activity;
alter table hour_activity
drop index hour_activity_index,
add index hour_activity_index (Id, `Date`, `Time`);

-- -------------------------------------------------------------------------------------------------
-- select some value from minute_Mets_Narrow 
select * 
from minute_Mets_Narrow 
limit 5;

-- show all indexes from minute_Mets_Narrow 
show index from minute_Mets_Narrow;
alter table minute_Mets_Narrow
add index minute_Mets_Narrow_index(Id,`Date`, `Time`);

-- -------------------------------------------------------------------------------------------------
-- select minute_sleep 
select *
from minute_sleep 
limit 5; 

-- show all indexes from minute_sleep
show index from minute_sleep;
alter table minute_sleep 
add index minute_sleep_index(Id,`Date`, `Time`);

-- -------------------------------------------------------------------------------------------------
-- select sleep_day
select *
from sleep_day 
limit 5;

-- show all indexes from sleep_day
show index from sleep_day;
alter table sleep_day 
drop index sleep_day_index,
add index sleep_day_index(Id,`Date`,`Time`);

-- -------------------------------------------------------------------------------------------------
-- select weight_log 
select *
from weight_log 
limit 5;

-- show all indexes from weight_log 
show index from weight_log;
alter table weight_log 
drop index weight_log_index,
add index weight_log_index(Id,`Date`,`Time`);


-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- create table Id (contain distinct Id from all table)
create table id (
	Id bigint unique not null
);

-- add all unique Id from all selection table
insert into id 
select distinct Id
from daily_activity
union
select distinct Id 
from hour_activity
union
select distinct Id 
from sleep_day
union
select distinct Id 
from minute_Mets_Narrow
union
select distinct Id 
from minute_sleep
union
select distinct Id 
from heartrate_seconds
union
select distinct Id 
from weight_log
order by Id;

-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- create table Date and Time (contain distinct date and time from each table)
-- for date table (only contain Date column)
-- create date table
create table `date` (
	`Date` date unique not null
);

-- add all unique Date value into date table
insert into `date`
select distinct `Date`
from daily_activity
union
select distinct `Date`
from hour_activity
union
select distinct `Date`
from sleep_day
union
select distinct `Date`
from minute_Mets_Narrow
union
select distinct `Date` 
from minute_sleep
union
select distinct `Date`
from heartrate_seconds
union
select distinct `Date`
from weight_log
order by `Date`;



-- -------------------------------------------------------------------------------------------------
-- for time table (only contain Time column)
-- create time table
create table `time`(
	`Time` time unique not null 
);

-- add all unique Time value into time table
insert into `time`
select distinct `Time`
from hour_activity
union
select distinct `Time`
from sleep_day
union
select distinct `Time`
from minute_Mets_Narrow
union
select distinct `Time` 
from minute_sleep
union
select distinct `Time`
from heartrate_seconds
union
select distinct `Time`
from weight_log
order by `Time`;
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- create foreign key for each table
-- with daily_activity
-- for id
alter table daily_activity 
add constraint fk_da_id 
foreign key (Id) references id(Id);
-- for Date
alter table daily_activity 
add constraint fk_da_date 
foreign key (`Date`) references date(`Date`);

-- -------------------------------------------------------------------------------------------------
-- with hourly_activity
-- for id
alter table hour_activity
add constraint fk_ha_id
foreign key (Id) references id(Id);

-- for Date
alter table hour_activity 
add constraint fk_ha_date
foreign key (`Date`) references date(`Date`);

-- for Time
alter table hour_activity 
add constraint fk_ha_time
foreign key (`Time`) references time(`Time`);

-- -------------------------------------------------------------------------------------------------
-- with sleep_day
-- for id
alter table sleep_day 
add constraint fk_sd_id
foreign key (Id) references id(Id);

-- for Date
alter table sleep_day 
add constraint fk_sd_date
foreign key (`Date`) references date(`Date`);

-- for Time
alter table sleep_day 
add constraint fk_sd_time
foreign key (`Time`) references time(`Time`);

-- -------------------------------------------------------------------------------------------------
-- with minute_sleep
-- for id
alter table minute_sleep 
add constraint fk_ms_id
foreign key (Id) references id(Id);

-- for Date
alter table minute_sleep 
add constraint fk_ms_date
foreign key (`Date`) references date(`Date`);

-- for Time
alter table minute_sleep 
add constraint fk_ms_time
foreign key (`Time`) references time(`Time`);

-- -------------------------------------------------------------------------------------------------
-- with minute_Mets_Narrow
-- for id
alter table minute_Mets_Narrow 
add constraint fk_mMN_id
foreign key (Id) references id(Id);

-- for Date
alter table minute_Mets_Narrow 
add constraint fk_mMN_date
foreign key (`Date`) references date(`Date`);

-- for Time
alter table minute_Mets_Narrow 
add constraint fk_mMN_time
foreign key (`Time`) references time(`Time`);

-- -------------------------------------------------------------------------------------------------
-- with heartrate_seconds
-- for id
alter table heartrate_seconds 
add constraint fk_hs_id
foreign key (Id) references id(Id);

-- for Date
alter table heartrate_seconds 
add constraint fk_hs_date
foreign key (`Date`) references date(`Date`);

-- for Time
alter table heartrate_seconds 
add constraint fk_hs_time
foreign key (`Time`) references time(`Time`);

-- -------------------------------------------------------------------------------------------------
-- with weight_log
-- for id
alter table weight_log 
add constraint fk_wl_id
foreign key (Id) references id(Id);

-- for Date
alter table weight_log 
add constraint fk_wl_date
foreign key (`Date`) references date(`Date`);

-- for Time
alter table weight_log 
add constraint fk_wl_time
foreign key (`Time`) references time(`Time`);


-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------

-- drop unselected tables
drop table dailyCalories_merged;
drop table dailyIntensities_merged;
drop table dailySteps_merged;
drop table hourlyCalories_merged;
drop table hourlyIntensities_merged;
drop table hourlySteps_merged;
drop table minuteCaloriesNarrow_merged;
drop table minuteCaloriesWide_merged;
drop table minuteIntensitiesNarrow_merged;
drop table minuteIntensitiesWide_merged;
drop table minuteStepsNarrow_merged;
drop table minuteStepsWide_merged;