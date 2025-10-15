SELECT *
FROM data_proff;

CREATE TABLE data_proff_staging
SELECT * FROM data_proff;

SELECT * FROM data_proff_staging;

ALTER TABLE data_proff_staging
RENAME COLUMN `Happiness_Learning _New_Things` TO Hap_learn_newThings;

ALTER TABLE data_proff_staging
RENAME COLUMN `Average Salary yearly (usd)` TO Avg_yearly_Sal,
RENAME COLUMN `date taken` TO Date_taken,
RENAME COLUMN `What Industry do you work in?` TO industry,
RENAME COLUMN `Favorite Programming Language` TO Fav_prog_Lang,
RENAME COLUMN `Male/Female?` TO Gender,
RENAME COLUMN `Current Age` TO Age,
RENAME COLUMN `Highest Level of Education` TO Education_level,
RENAME COLUMN `Happiness with Management` TO Hap_with_Mgt,
RENAME COLUMN `Happiness with Coworkers` TO Hap_with_Coworkers,
RENAME COLUMN `Happiness with worklife balance` TO Hap_with_worklife_bal,
RENAME COLUMN `Happiness with salary` TO Hap_with_sal;

SELECT COUNT(id) FROM data_proff_staging;

SELECT * 
FROM data_proff_staging;

SELECT date_taken, STR_TO_DATE(date_taken, '%m/%d/%Y')
FROM data_proff_staging;

UPDATE data_proff_staging
SET date_taken =  STR_TO_DATE(date_taken, '%m/%d/%Y');

ALTER TABLE data_proff_staging
MODIFY COLUMN date_taken DATE;

SELECT * FROM data_proff_staging;

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY ID, date_taken, job_title, Switched_careers,Avg_yearly_Sal, industry, Fav_prog_Lang, Hap_with_sal, 
Hap_with_worklife_bal, Hap_with_Coworkers, Hap_with_Mgt, Hap_learn_newThings, difficulty_into_data,
gender, age, country, education_level, ethnicity) as row_num
FROM data_proff_staging
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

SELECT DISTINCT job_title, round(avg(Avg_yearly_Sal), 2) as avg_sal
FROM data_proff_staging
group by job_title;

SELECT DISTINCT job_title, round(avg(Avg_yearly_Sal) OVER(PARTITION BY Job_title ORDER BY job_title asc),2) avg_sal
FROM data_proff_staging
ORDER BY avg_sal DESC;

SELECT * FROM data_proff_staging;

SELECT DISTINCT industry, COUNT(Job_title) OVER(PARTITION BY industry) as No_of_Profesionals
FROM data_proff_staging
ORDER BY no_of_Profesionals DESC;

SELECT * FROM data_proff_staging;

WITH diffEntry_cte AS
(
SELECT * 
FROM data_proff_staging
WHERE gender = 'male'
AND Difficulty_into_Data = 'very difficult'
)
SELECT count(id) FROM diffEntry_cte;

SELECT DISTINCT fav_prog_lang FROM data_proff_staging
WHERE Job_title = 'Data Analyst';

















