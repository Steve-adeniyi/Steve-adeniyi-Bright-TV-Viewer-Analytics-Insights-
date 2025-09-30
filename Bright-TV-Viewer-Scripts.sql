-- Bright TV Viewer Cinsumption Exploratory Data Analysis (EDA)---

SELECT * FROM stevedata.data.user_profile;

-- Checking the UserID number---
SELECT COUNT(DISTINCT UserID) AS total_users
FROM stevedata.data.user_profile;

-- Counting number of the province and name of the province---
SELECT DISTINCT province
FROM stevedata.data.user_profile;

---Checking the Minimum Age---
SELECT MIN(Age)
FROM stevedata.data.user_profile;

--- Checking the Maximum Age---
SELECT MAX(Age)
FROM stevedata.data.user_profile;

---Checking the Gender---
SELECT DISTINCT gender
FROM stevedata.data.user_profile;

---Checking the Race---
SELECT DISTINCT race
FROM stevedata.data.user_profile;

---Checking channel2 number---
SELECT DISTINCT channel2
FROM stevedata.data.viewship;

---Checking the start Duration 2---
SELECT DISTINCT `Duration 2` AS start_minute
FROM stevedata.data.viewship;

---Checking the stop duration 2---
SELECT DISTINCT `Duration 2` AS stop_minute
FROM stevedata.data.viewship;

---Select statement---
SELECT
  u.userID AS userID,
  u.gender,
  u.province,
  u.race,
  v.channel2,
  v.`Duration 2` AS duration2,
  v.userID AS v_userID,

  ---Convert UTC timestamp to SAST (UTC+2)---
  
  hour(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) AS hour_sast,
  
  SUM(v.`Duration 2`) AS total_minutes_consumption,
  
  from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) AS timestamp_sast,
  
  date(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) AS date_sast,
  
  date_format(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg'),'MMMM')) AS monthname_sast,
  
  dayname(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) AS weekday_sast,
  
  month(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) AS monthid_sast,

  ---Create the time bucket---
  
  CASE
    WHEN hour(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) BETWEEN 6 AND 11 THEN '01.Morning'
	
    WHEN hour(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) BETWEEN 12 AND 16 THEN '02.Afternoon'
	
    WHEN hour( from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) BETWEEN 17 AND 20 THEN '03.Evening'
	
    WHEN hour(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')) BETWEEN 21 AND 23 THEN '04.Night'
	
    ELSE '05.Midnight'
	
  END AS time_bucket,

  ---Creating the age group---
  
  CASE
    WHEN u.age BETWEEN 0 AND 18 THEN '01.00-18:Teenager'
    WHEN u.age BETWEEN 19 AND 30 THEN '02.19-30:Young Adult'
    WHEN u.age BETWEEN 31 AND 45 THEN '03.31-45:Adult'
    WHEN u.age BETWEEN 46 AND 60 THEN '04.46-60:Senior'
    ELSE '05.60+:Elderly'
  END AS age_group
  
FROM stevedata.data.user_profile AS u
LEFT JOIN stevedata.data.viewship AS v
  ON u.UserID = v.UserID
  
GROUP BY
  u.userID,
  u.gender,
  u.province,
  u.race,
  v.channel2,
  v.`Duration 2`,
  v.userID,
  
  from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg'),
  
  date(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')),
  
  hour(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')),
  
  date_format(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg'),'MMMM')),
  
  dayname(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')),
  
  month(from_utc_timestamp(to_timestamp(v.RecordDate2, 'M/d/yyyy H:mm'),'Africa/Johannesburg')),
  
  CASE
    WHEN u.age BETWEEN 0 AND 18 THEN '01.00-18:Teenager'
    WHEN u.age BETWEEN 19 AND 30 THEN '02.19-30:Young Adult'
    WHEN u.age BETWEEN 31 AND 45 THEN '03.31-45:Adult'
    WHEN u.age BETWEEN 46 AND 60 THEN '04.46-60:Senior'
    ELSE '05.60+:Elderly'
  END
  
ORDER BY total_minutes_consumption DESC;
