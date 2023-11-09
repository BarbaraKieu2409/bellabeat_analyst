/*
 * Analysis
 * Main business questions:
 *  - What are some trends in smart device usage?
 *  - How could these trends apply to Bellabeat customers?
 *  - How could these trends help influence Bellabeat marketing strategy?
 * 
 * */

use bellabeat_db;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- ---------------------------------------------- Descriptive Analysis -------------------------------------------------- --
-- ---------------------------------------------------------------------------------------------------------------------- --
-- ------------------------ Find total, min, max, mean - avg, mode, med, Q1, Q3, std ------------------------------------ --

-- for daily_activity

select * from daily_activity;

-- set total_row in daily_activity table
select round(count(*)*0.25)-1 as q1_row from daily_activity;
select round(count(*)*0.5)-1 as q2_row from daily_activity;
select round(count(*)*0.75)-1 as q3_row from daily_activity;

select -- total
	'total' as measure,
	count(*) as 'all',
	count(distinct TotalSteps) as 'TotalSteps',
	count(distinct TotalDistance) as 'TotalDistance',
	count(distinct TrackerDistance) as 'TrackerDistance',
	count(distinct LoggedActivitiesDistance) as 'LoggedActivitiesDistance', 
	count(distinct VeryActiveDistance) as 'VeryActiveDistance',
	count(distinct ModeratelyActiveDistance) as 'ModeratelyActiveDistance',
	count(distinct LightActiveDistance) as 'LightActiveDistance',
	count(distinct SedentaryActiveDistance) as 'SedentaryActiveDistance',
	count(distinct VeryActiveMinutes) as 'VeryActiveMinutes',
	count(distinct FairlyActiveMinutes) as 'FairlyActiveMinutes',
	count(distinct LightlyActiveMinutes) as 'LightActiveMinutes',
	count(distinct SedentaryMinutes) as 'SedentaryMinutes',
	count(distinct Calories) as 'Calories'
from daily_activity
union
select -- max
	'max' as measure,
	NULL as 'all',
	max(TotalSteps) as 'TotalSteps',
	max(TotalDistance) as 'TotalDistance',
	max(TrackerDistance) as 'TrackerDistance',
	max(LoggedActivitiesDistance) as 'LoggedActivitiesDistance',
	max(VeryActiveDistance) as 'VeryActiveDistance',
	max(ModeratelyActiveDistance) as 'ModeratelyActiveDistance',
	max(LightActiveDistance) as 'LightActiveDistance',
	max(SedentaryActiveDistance) as 'SedentaryActiveDistance',
	max(VeryActiveMinutes) as 'VeryActiveMinutes',
	max(FairlyActiveMinutes) as 'FairlyActiveMinutes',
	max(LightlyActiveMinutes) as 'LightActiveMinutes',
	max(SedentaryMinutes) as 'SedentaryMinutes',
	max(Calories) as 'Calories'
from daily_activity
union
select * -- Q3
from 
	(select 'Q3' as measure, '' as 'all') as info,
	(select TotalSteps from daily_activity order by TotalSteps limit 1 offset 704) as TotalSteps,
	(select TotalDistance from daily_activity order by TotalDistance limit 1 offset 704) as TotalDistance,
	(select TrackerDistance from daily_activity order by TrackerDistance limit 1 offset 704) as TrackerDistance,
	(select LoggedActivitiesDistance from daily_activity order by LoggedActivitiesDistance limit 1 offset 704) as LoggedActivitiesDistance,
	(select VeryActiveDistance from daily_activity order by VeryActiveDistance limit 1 offset 704) as VeryActiveDistance, 
	(select ModeratelyActiveDistance from daily_activity order by ModeratelyActiveDistance limit 1 offset 704) as ModeratelyActiveDistance, 
	(select LightActiveDistance from daily_activity order by LightActiveDistance limit 1 offset 704) as LightActiveDistance, 
	(select SedentaryActiveDistance from daily_activity order by SedentaryActiveDistance limit 1 offset 704) as SedentaryActiveDistance, 
	(select VeryActiveMinutes from daily_activity order by VeryActiveMinutes limit 1 offset 704) as VeryActiveMinutes, 
	(select FairlyActiveMinutes from daily_activity da order by FairlyActiveMinutes limit 1 offset 704) as FairlyActiveMinutes, 
	(select LightlyActiveMinutes from daily_activity order by LightActiveDistance limit 1 offset 704) as LightlyActiveMinutes, 
	(select SedentaryMinutes from daily_activity order by SedentaryMinutes limit 1 offset 704) as SedentaryMinutes, 
	(select Calories from daily_activity order by Calories limit 1 offset 704) as Calories
union
select * -- Q2 median
from 
	(Select 'Q2' as measure, '' as 'all') as info, 
	(select TotalSteps from daily_activity order by TotalSteps limit 1 offset 469) as TotalSteps,
	(select TotalDistance from daily_activity order by TotalDistance limit 1 offset 469) as TotalDistance,
	(select TrackerDistance from daily_activity order by TrackerDistance limit 1 offset 469) as TrackerDistance,
	(select LoggedActivitiesDistance from daily_activity order by LoggedActivitiesDistance limit 1 offset 469) as LoggedActivitiesDistance,
	(select VeryActiveDistance from daily_activity order by VeryActiveDistance limit 1 offset 469) as VeryActiveDistance, 
	(select ModeratelyActiveDistance from daily_activity order by ModeratelyActiveDistance limit 1 offset 469) as ModeratelyActiveDistance, 
	(select LightActiveDistance from daily_activity order by LightActiveDistance limit 1 offset 469) as LightActiveDistance, 
	(select SedentaryActiveDistance from daily_activity order by SedentaryActiveDistance limit 1 offset 469) as SedentaryActiveDistance, 
	(select VeryActiveMinutes from daily_activity order by VeryActiveMinutes limit 1 offset 469) as VeryActiveMinutes, 
	(select FairlyActiveMinutes from daily_activity da order by FairlyActiveMinutes limit 1 offset 469) as FairlyActiveMinutes, 
	(select LightlyActiveMinutes from daily_activity order by LightActiveDistance limit 1 offset 469) as LightlyActiveMinutes, 
	(select SedentaryMinutes from daily_activity order by SedentaryMinutes limit 1 offset 469) as SedentaryMinutes, 
	(select Calories from daily_activity order by Calories limit 1 offset 469) as Calories
union
select -- mean 
	'mean' as measure, 
	NULL as 'all',
	avg(TotalSteps) as 'TotalSteps',
	avg(TotalDistance) as 'TotalDistance',
	avg(TrackerDistance) as 'TrackerDistance',
	avg(LoggedActivitiesDistance) as 'LoggedActivitiesDistance',
	avg(VeryActiveDistance) as 'VeryActiveDistance',
	avg(ModeratelyActiveDistance) as 'ModeratelyActiveDistance',
	avg(LightActiveDistance) as 'LightActiveDistance',
	avg(SedentaryActiveDistance) as 'SedentaryActiveDistance',
	avg(VeryActiveMinutes) as 'VeryActiveMinutes',
	avg(FairlyActiveMinutes) as 'FairlyActiveMinutes',
	avg(LightlyActiveMinutes) as 'LightActiveMinutes',
	avg(SedentaryMinutes) as 'SedentaryMinutes',
	avg(Calories) as 'Calories'
from daily_activity
union
select -- mode 
	'mode' as measure, '' as 'all',
	TotalSteps, 
	TotalDistance,
	TrackerDistance,
	LoggedActivitiesDistance,
	VeryActiveDistance,
	ModeratelyActiveDistance,
	LightActiveDistance,
	SedentaryActiveDistance,
	VeryActiveMinutes,
	FairlyActiveMinutes,
	LightlyActiveMinutes,
	SedentaryMinutes,
	Calories
from 
	(
		select 
			TotalSteps, count(TotalSteps) as TotalSteps_count 
		from daily_activity 
		group by TotalSteps 
		order by TotalSteps_count desc 
		limit 1
	) as TotalSteps,
	(
		select 
			TotalDistance, count(TotalDistance) as TotalDistance_count
		from daily_activity 
		group by TotalDistance
		order by TotalDistance_count desc
		limit 1
	) as TotalDistance,
	(
		select 
			TrackerDistance, count(TrackerDistance) as TrackerDistance_count 
		from daily_activity 
		group by TrackerDistance
		order by TrackerDistance_count desc 
		limit 1
	) as TrackerDistance,
	( 
		select 
			LoggedActivitiesDistance, count(LoggedActivitiesDistance) as LoggedActivitiesDistance_count
		from daily_activity 
		group by LoggedActivitiesDistance
		order by LoggedActivitiesDistance_count desc 
		limit 1
	) as LoggedActivitiesDistance,
	( 
		select 
			VeryActiveDistance, count(VeryActiveDistance) as VeryActiveDistance_count
		from daily_activity 
		group by VeryActiveDistance
		order by VeryActiveDistance_count desc 
		limit 1
	) as VeryActiveDistance,
	( 
		select 
			ModeratelyActiveDistance, count(ModeratelyActiveDistance) as ModeratelyActiveDistance_count
		from daily_activity 
		group by ModeratelyActiveDistance
		order by ModeratelyActiveDistance_count desc 
		limit 1
	) as ModeratelyActiveDistance,
	( 
		select 
			LightActiveDistance, count(LightActiveDistance) as LightActiveDistance_count
		from daily_activity 
		group by LightActiveDistance
		order by LightActiveDistance_count desc 
		limit 1
	) as LightActiveDistance,
	( 
		select 
			SedentaryActiveDistance, count(SedentaryActiveDistance) as SedentaryActiveDistance_count
		from daily_activity 
		group by SedentaryActiveDistance
		order by SedentaryActiveDistance_count desc 
		limit 1
	) as SedentaryActiveDistance,
	( 
		select 
			VeryActiveMinutes, count(VeryActiveMinutes) as VeryActiveMinutes_count
		from daily_activity 
		group by VeryActiveMinutes
		order by VeryActiveMinutes_count desc 
		limit 1
	) as VeryActiveMinutes,
	( 
		select 
			FairlyActiveMinutes, count(FairlyActiveMinutes) as FairlyActiveMinutes_count
		from daily_activity 
		group by FairlyActiveMinutes
		order by FairlyActiveMinutes_count desc 
		limit 1
	) as FairlyActiveMinutes,
	( 
		select 
			LightlyActiveMinutes, count(LightlyActiveMinutes) as LightlyActiveMinutes_count
		from daily_activity 
		group by LightlyActiveMinutes
		order by LightlyActiveMinutes_count desc 
		limit 1
	) as LightlyActiveMinutes,
	( 
		select 
			SedentaryMinutes, count(SedentaryMinutes) as SedentaryMinutes_count
		from daily_activity 
		group by SedentaryMinutes
		order by SedentaryMinutes_count desc 
		limit 1
	) as SedentaryMinutes,
	( 
		select 
			Calories, count(Calories) as Calories_count
		from daily_activity 
		group by Calories
		order by Calories_count desc 
		limit 1
	) as Calories
union		
select * -- Q1
from 
	(Select 'Q1' as measure, '' as 'all') as info, 
	(select TotalSteps from daily_activity order by TotalSteps limit 1 offset 234) as TotalSteps,
	(select TotalDistance from daily_activity order by TotalDistance limit 1 offset 234) as TotalDistance,
	(select TrackerDistance from daily_activity order by TrackerDistance limit 1 offset 234) as TrackerDistance,
	(select LoggedActivitiesDistance from daily_activity order by LoggedActivitiesDistance limit 1 offset 234) as LoggedActivitiesDistance,
	(select VeryActiveDistance from daily_activity order by VeryActiveDistance limit 1 offset 234) as VeryActiveDistance, 
	(select ModeratelyActiveDistance from daily_activity order by ModeratelyActiveDistance limit 1 offset 234) as ModeratelyActiveDistance, 
	(select LightActiveDistance from daily_activity order by LightActiveDistance limit 1 offset 234) as LightActiveDistance, 
	(select SedentaryActiveDistance from daily_activity order by SedentaryActiveDistance limit 1 offset 234) as SedentaryActiveDistance, 
	(select VeryActiveMinutes from daily_activity order by VeryActiveMinutes limit 1 offset 234) as VeryActiveMinutes, 
	(select FairlyActiveMinutes from daily_activity da order by FairlyActiveMinutes limit 1 offset 234) as FairlyActiveMinutes, 
	(select LightlyActiveMinutes from daily_activity order by LightActiveDistance limit 1 offset 234) as LightlyActiveMinutes, 
	(select SedentaryMinutes from daily_activity order by SedentaryMinutes limit 1 offset 234) as SedentaryMinutes, 
	(select Calories from daily_activity order by Calories limit 1 offset 234) as Calories
union
select -- min 
	'min' as measure,
	NULL as 'all',
	min(TotalSteps) as 'TotalSteps',
	min(TotalDistance) as 'TotalDistance',
	min(TrackerDistance) as 'TrackerDistance',
	min(LoggedActivitiesDistance) as 'LoggedActivitiesDistance',
	min(VeryActiveDistance) as 'VeryActiveDistance',
	min(ModeratelyActiveDistance) as 'ModeratelyActiveDistance',
	min(LightActiveDistance) as 'LightActiveDistance',
	min(SedentaryActiveDistance) as 'SedentaryActiveDistance',
	min(VeryActiveMinutes) as 'VeryActiveMinutes',
	min(FairlyActiveMinutes) as 'FairlyActiveMinutes',
	min(LightlyActiveMinutes) as 'LightActiveMinutes',
	min(SedentaryMinutes) as 'SedentaryMinutes',
	min(SedentaryMinutes) as 'SedentaryMinutes'
from daily_activity;
	
-- ---------------------------------------------------------------------------------------------------------------------- --
-- for heartrate_seconds 
select * from heartrate_seconds;

-- set total_row in heartrate_seconds table
select round(count(*)*0.25)-1 as q1_row from heartrate_seconds;
select round(count(*)*0.5)-1 as q2_row from heartrate_seconds;
select round(count(*)*0.75)-1 as q3_row from heartrate_seconds;

select -- total 
	'total' as measure,
	count(*) as 'all',
	count(distinct Value) as 'Value'
	from heartrate_seconds
union
select -- max
	'max' as measure,
	NULL as 'all',
	max(Value) as 'Value'
from heartrate_seconds
union
select * -- Q3
from 
	(select 'Q3' as measure, '' as 'all') as info,
	(select Value from heartrate_seconds order by Value limit 1 offset 1862743) as Value
union
select * -- Q2 median
from 
	(Select 'Q2' as measure, '' as 'all') as info, 
	(select Value from heartrate_seconds order by Value limit 1 offset 1241828) as Value
union
select -- mean 
	'mean' as measure, 
	NULL as 'all',
	avg(Value) as 'Value'
from heartrate_seconds
union
select -- mode 
	'mode' as measure, '' as 'all',
	Value
from 
	(
		select 
			Value, count(Value) as Value_count 
		from heartrate_seconds
		group by Value
		order by Value_count desc 
		limit 1
	) as Value
union	
select * -- Q1
from 
	(Select 'Q1' as measure, '' as 'all') as info, 
	(select Value from heartrate_seconds order by Value limit 1 offset 620914) as Value
union	
select -- min 
	'min' as measure,
	NULL as 'all',
	min(Value) as 'Value'
from heartrate_seconds;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- for hour_activity 
select * from hour_activiy;
-- set total_row in hour_activity table 
select round(count(*)*0.25)-1 as q1_row from hour_activity ;
select round(count(*)*0.5)-1 as q2_row from hour_activity;
select round(count(*)*0.75)-1 as q3_row from hour_activity;

select -- total 
	'total' as measure,
	count(*) as 'all',
	count(distinct Calories) as 'Calories',
	count(distinct StepTotal) as 'StepTotal',
	count(distinct TotalIntensity) as 'TotalIntensity',
	count(distinct AverageIntensity) as 'AverageIntensity'
	from hour_activity
union
 select -- max
	'max' as measure,
	NULL as 'all',
	max(Calories) as 'Calories',
	max(StepTotal) as 'StepTotal',
	max(TotalIntensity) as 'TotalIntensity',
	max(AverageIntensity) as 'AverageIntensity'
from hour_activity
union
select * -- Q3
from 
	(select 'Q3' as measure, '' as 'all') as info,
	(select Calories from hour_activity order by Calories limit 1 offset 16573) as Calories,
	(select StepTotal from hour_activity order by StepTotal limit 1 offset 16573) as StepTotal, 
	(select TotalIntensity from hour_activity order by TotalIntensity limit 1 offset 16573) as TotalIntensity, 
	(select AverageIntensity from hour_activity order by AverageIntensity limit 1 offset 16573) as AverageIntensity
union
select * -- Q2 median
from 
	(Select 'Q2' as measure, '' as 'all') as info, 
	(select Calories from hour_activity order by Calories limit 1 offset 11049) as Calories,
	(select StepTotal from hour_activity order by StepTotal limit 1 offset 11049) as StepTota, 
	(select TotalIntensity from hour_activity order by TotalIntensity limit 1 offset 11049) as TotalIntensity,
	(select AverageIntensity from hour_activity order by AverageIntensity limit 1 offset 11049) as AverageIntensity
union
	select -- mean 
	'mean' as measure, 
	NULL as 'all',
	avg(Calories) as 'Calories',
	avg(StepTotal) as 'StepTotal',
	avg(TotalIntensity) as 'TotalIntensity',
	avg(AverageIntensity) as 'AverageIntensity'
from hour_activity
union
select -- mode 
	'mode' as measure, '' as 'all',
	Calories,
	StepTotal,
	TotalIntensity,
	AverageIntensity
from 
	(
		select 
			Calories, count(Calories) as Calories_count 
		from hour_activity 
		group by Calories
		order by Calories_count desc 
		limit 1
	) as Calories,
	(
		select 
			StepTotal, count(StepTotal) as StepTotal_count 
		from hour_activity 
		group by StepTotal
		order by StepTotal_count desc 
		limit 1 
	) as StepTotal,
	(
		select 
			TotalIntensity, count(TotalIntensity) as TotalIntensity_count 
		from hour_activity 
		group by TotalIntensity
		order by TotalIntensity_count desc 
		limit 1 
	) as TotalIntensity,
	(
		select 
			AverageIntensity, count(AverageIntensity) as AverageIntensity_count 
		from hour_activity 
		group by AverageIntensity
		order by AverageIntensity_count desc 
		limit 1 
	) as AverageIntensity
union
select * -- Q1
from 
	(Select 'Q1' as measure, '' as 'all') as info, 
	(select Calories from hour_activity order by Calories limit 1 offset 5524) as Calories,
	(select StepTotal from hour_activity order by StepTotal limit 1 offset 5524) as StepTotal,
	(select TotalIntensity from hour_activity order by TotalIntensity limit 1 offset 5524) as TotalIntensity,
	(select AverageIntensity from hour_activity order by AverageIntensity limit 1 offset 5524) as AverageIntensity
union
select -- min 
	'min' as measure,
	NULL as 'all',
	min(Calories) as 'Calories',
	min(StepTotal) as 'StepTotal',
	min(TotalIntensity) as 'TotalIntensity',
	min(AverageIntensity) as 'AverageIntensity'
from hour_activity;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- for minute_Mets_Narrow
select * from minute_Mets_Narrow ;
-- set total_row in hour_activity table 
select round(count(*)*0.25)-1 as q1_row from minute_Mets_Narrow ;
select round(count(*)*0.5)-1 as q2_row from minute_Mets_Narrow;
select round(count(*)*0.75)-1 as q3_row from minute_Mets_Narrow;

select -- total
'total' as measure,
	count(*) as 'all',
	count(distinct METs) as 'METs'
from minute_Mets_Narrow
union
select -- max
	'max' as measure,
	NULL as 'all',
	max(METs) as 'METs'
from minute_Mets_Narrow
union
select * -- Q3
from 
	(select 'Q3' as measure, '' as 'all') as info,
	(select METs from minute_Mets_Narrow order by METs limit 1 offset 994184) as METs
union	
select * -- Q2 median 
from 
	(Select 'Q2' as measure, '' as 'all') as info, 
	(select METs from minute_Mets_Narrow order by METs limit 1 offset 662789) as METs
union	
select -- mean 
'mean' as measure, 
	NULL as 'all',
	avg(METs) as 'METs'
from minute_Mets_Narrow
union
select -- mode 
	'mode' as measure, '' as 'all',
	METs
from 
	(
		select 
			METs, count(METs) as METs_count 
		from minute_Mets_Narrow
		group by METs
		order by METs_count desc 
		limit 1
	) as METs
union	
select * -- Q1
from 
	(Select 'Q1' as measure, '' as 'all') as info, 
	(select METs from minute_Mets_Narrow order by METs limit 1 offset 331394) as METs
union
select -- min 
'min' as measure,
	NULL as 'all',
	min(METs) as 'METs'
from minute_Mets_Narrow;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- for minute_sleep
select * from minute_sleep ;
-- set total_row in hour_activity table 

select -- total
'total' as measure,
	count(*) as 'all',
	count(distinct value) as 'value'
from minute_sleep
union
select -- mode 
	'mode' as measure, '' as 'all',
	value
from 
	(
		select 
			value, count(value) as value_count 
		from minute_sleep 
		group by value
		order by value_count desc 
		limit 1
	) as value;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- for sleep_day
select * from sleep_day ;
-- set total_row in hour_activity table 
select round(count(*)*0.25)-1 as q1_row from sleep_day;
select round(count(*)*0.5)-1 as q2_row from sleep_day;
select round(count(*)*0.75)-1 as q3_row from sleep_day;

select -- total 
'total' as measure,
	count(*) as 'all',
	count(distinct TotalSleepRecords) as 'TotalSleepRecords',
	count(distinct TotalMinutesAsleep) as 'TotalMinutesAsleep',
	count(distinct TotalTimeInBed) as 'TotalTimeInBed'
from sleep_day 
union
select -- max
'max' as measure,
	NULL as 'all',
	max(TotalSleepRecords) as 'TotalSleepRecords',
	max(TotalMinutesAsleep) as 'TotalMinutesAsleep',
	max(TotalTimeInBed) as 'TotalTimeInBed'
from sleep_day 
union
select * -- Q3
from 
	(select 'Q3' as measure, '' as 'all') as info,
	(select TotalSleepRecords from sleep_day order by TotalSleepRecords limit 1 offset 307) as TotalSleepRecords,
	(select TotalMinutesAsleep from sleep_day order by TotalMinutesAsleep limit 1 offset 307) as TotalMinutesAsleep,
	(select TotalTimeInBed from sleep_day order by TotalTimeInBed limit 1 offset 307) as TotalTimeInBed
union	
select * -- Q2 median 
from 
	(Select 'Q2' as measure, '' as 'all') as info, 
	(select TotalSleepRecords from sleep_day order by TotalSleepRecords limit 1 offset 204) as TotalSleepRecords,
	(select TotalMinutesAsleep from sleep_day order by TotalMinutesAsleep limit 1 offset 204) as TotalMinutesAsleep,
	(select TotalTimeInBed from sleep_day order by TotalTimeInBed limit 1 offset 204) as TotalTimeInBed
union	
select -- mean 
'mean' as measure, 
	NULL as 'all',
	avg(TotalSleepRecords) as 'TotalSleepRecords',
	avg(TotalMinutesAsleep) as 'TotalMinutesAsleep',
	avg(TotalTimeInBed) as 'TotalTimeInBed'
from sleep_day
union
select -- mode 
	'mode' as measure, '' as 'all',
	TotalSleepRecords,
	TotalMinutesAsleep,
	TotalTimeInBed
from 
	(
		select 
		TotalSleepRecords, count(TotalSleepRecords) as TotalSleepRecords_count 
		from sleep_day
		group by TotalSleepRecords
		order by TotalSleepRecords_count desc 
		limit 1
	) as TotalSleepRecords,
	(
		select 
		TotalMinutesAsleep, count(TotalMinutesAsleep) as TotalMinutesAsleep_count 
		from sleep_day
		group by TotalMinutesAsleep
		order by TotalMinutesAsleep_count desc 
		limit 1
	) as TotalMinutesAsleep,
	(
		select 
		TotalTimeInBed, count(TotalTimeInBed) as TotalTimeInBed_count 
		from sleep_day
		group by TotalTimeInBed
		order by TotalTimeInBed_count desc 
		limit 1
	) as TotalTimeInBed
union	
select * -- Q1
from 
	(Select 'Q1' as measure, '' as 'all') as info, 
	(select TotalSleepRecords from sleep_day order by TotalSleepRecords limit 1 offset 102) as TotalSleepRecords,
	(select TotalMinutesAsleep from sleep_day order by TotalMinutesAsleep limit 1 offset 102) as TotalMinutesAsleep,
	(select TotalTimeInBed from sleep_day order by TotalTimeInBed limit 1 offset 102) as TotalTimeInBed
union
select -- min 
'min' as measure,
	NULL as 'all',
	min(TotalSleepRecords) as 'TotalSleepRecords',
	min(TotalMinutesAsleep) as 'TotalMinutesAsleep',
	min(TotalTimeInBed) as 'TotalTimeInBed'
from sleep_day;

-- ---------------------------------------------------------------------------------------------------------------------- --
-- for weight_log
select * from weight_log;
-- set total_row in weight_log table 
select round(count(*)*0.25)-1 as q1_row from weight_log;
select round(count(*)*0.5)-1 as q2_row from weight_log;
select round(count(*)*0.75)-1 as q3_row from weight_log;

select -- total 
'total' as measure,
	count(*) as 'all',
	count(distinct WeightKg) as 'WeightKg',
	count(distinct WeightPounds) as 'WeightPounds',
	count(distinct Fat) as 'Fat',
	count(distinct BMI) as 'BMI',
	count(distinct IsManualReport) as 'IsManualReport'
from weight_log 
union
select -- max
'max' as measure,
	NULL as 'all',
	max(WeightKg) as 'WeightKg',
	max(WeightPounds) as 'WeightPounds',
	max(Fat) as 'Fat',
	max(BMI) as 'BMI',
	max(IsManualReport) as 'IsManualReport'
from weight_log
union
select * -- Q3
from 
	(select 'Q3' as measure, '' as 'all') as info,
	(select WeightKg from weight_log order by WeightKg limit 1 offset 49) as WeightKg,
	(select WeightPounds from weight_log order by WeightPounds limit 1 offset 49) as WeightPounds,
	(select Fat from weight_log order by Fat limit 1 offset 49) as Fat,
	(select BMI from weight_log order by BMI limit 1 offset 49) as BMI,
	(select IsManualReport from weight_log order by IsManualReport limit 1 offset 49) as IsManualReport
union	
select * -- Q2 median 
from 
	(Select 'Q2' as measure, '' as 'all') as info, 
	(select WeightKg from weight_log order by WeightKg limit 1 offset 33) as WeightKg,
	(select WeightPounds from weight_log order by WeightPounds limit 1 offset 33) as WeightPounds,
	(select Fat from weight_log order by Fat limit 1 offset 33) as Fat,
	(select BMI from weight_log order by BMI limit 1 offset 33) as BMI,
	(select IsManualReport from weight_log order by IsManualReport limit 1 offset 33) as IsManualReport
union	
select -- mean 
'mean' as measure, 
	NULL as 'all',
	avg(WeightKg) as 'WeightKg',
	avg(WeightPounds) as 'WeightPounds',
	avg(Fat) as 'Fat',
	avg(BMI) as 'BMI',
	avg(IsManualReport) as 'IsManualReport'
from weight_log
union
select -- mode 
	'mode' as measure, '' as 'all',
	WeightKg,
	WeightPounds,
	Fat,
	BMI,
	IsManualReport
from 
	(
		select 
		WeightKg, count(WeightKg) as WeightKg_count 
		from weight_log
		group by WeightKg
		order by WeightKg_count desc 
		limit 1
	) as WeightKg,
	(
		select 
		WeightPounds, count(WeightPounds) as WeightPounds_count 
		from weight_log
		group by WeightPounds
		order by WeightPounds_count desc 
		limit 1
	) as WeightPounds,
	(
		select 
		Fat, count(Fat) as Fat_count 
		from weight_log
		group by Fat
		order by Fat_count desc 
		limit 1
	) as Fat,
	(
		select 
		BMI, count(BMI) as BMI_count 
		from weight_log
		group by BMI
		order by BMI_count desc 
		limit 1
	) as BMI,
	(
		select 
		IsManualReport, count(IsManualReport) as IsManualReport_count 
		from weight_log
		group by IsManualReport
		order by IsManualReport_count desc 
		limit 1
	) as IsManualReport
union	
select * -- Q1
from 
	(Select 'Q1' as measure, '' as 'all') as info, 
	(select WeightKg from weight_log order by WeightKg limit 1 offset 16) as WeightKg,
	(select WeightPounds from weight_log order by WeightPounds limit 1 offset 16) as WeightPounds,
	(select Fat from weight_log order by Fat limit 1 offset 16) as Fat,
	(select BMI from weight_log order by BMI limit 1 offset 16) as BMI,
	(select IsManualReport from weight_log order by IsManualReport limit 1 offset 16) as IsManualReport
union
select -- min 
'min' as measure,
	NULL as 'all',
	min(WeightKg) as 'WeightKg',
	min(WeightPounds) as 'WeightPounds',
	min(Fat) as 'Fat',
	min(BMI) as 'BMI',
	min(IsManualReport) as 'IsManualReport'
from weight_log;
