--Inspecting dataset to check data quality and completeness.
-- 74,283 dataset.
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

-- Inspect each respective columns,To comprehend the dataset.
-- low,high,medium.
SELECT
	DISTINCT(Physical_Activity_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Current,Former,Never.
SELECT
	DISTINCT(Smoking_Status)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Regularly,Occasionally,Never
SELECT
	DISTINCT(Alcohol_Consumption)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Normal,High.
SELECT
	DISTINCT(Cholesterol_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- High,Medium,Low.
SELECT
	DISTINCT(Depression_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Good,Poor,Average.
SELECT
	DISTINCT(Sleep_Quality)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Unhealthy,Healthy,Average.
SELECT
	DISTINCT(Dietary_Habits)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Low,High,Medium
SELECT
	DISTINCT(Air_Pollution_Exposure)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Retired,Employed,Unemployed.
SELECT
	DISTINCT(Employment_Status)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Single,Widowed,Married.
SELECT
	DISTINCT(Marital_Status)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Low,High,Medium.
SELECT
	DISTINCT(Social_Engagement_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Low,High,Medium.
SELECT
	DISTINCT(Income_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]


-- Low,High,Medium.
SELECT
	DISTINCT(Stress_Levels)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Urban,Rural.
SELECT
	DISTINCT(Urban_vs_Rural_Living)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Quinquagenarians,Septuagenarians,Nonagenarians,Sexagenarians.
SELECT
	DISTINCT(Age_Group)
	FROM [Femi].[dbo].[Alzheimers Dataset]


-- Datatypes Overview.
EXEC sp_columns [Alzheimers Dataset]

-- I created a new column 'Age_Group'.
ALTER TABLE [Alzheimers Dataset]
ADD Age_Group VARCHAR(30)


/*I inputted Quinquagenarians,Sexagenarians,Septuagenarians,Octogenarians,and Nonagenarians into column Age_ Group*/
UPDATE [Femi].[dbo].[Alzheimers Dataset]
SET Age_Group = 
			CASE 
			WHEN Age BETWEEN 50 AND 59 THEN 'Quinquagenarians'
			WHEN Age BETWEEN 60 AND 69 THEN 'Sexagenarians'
			WHEN Age BETWEEN 70 AND 79 THEN 'Septuagenarians'
			WHEN Age BETWEEN 80 AND 89 THEN 'Octogenarians'
			WHEN Age BETWEEN 90 AND 94 THEN 'Nonagenarians'
			ELSE 'Unknown'
		END 

-- Explanatory Data Analysis.

--1)What was the total number of countries in the dataset?
SELECT 
	 Count(DISTINCT Country) AS Total_Countries 
	 FROM [Femi].[dbo].[Alzheimers Dataset]

--2)How does Alzheimer's disease risk vary by age group?
SELECT 
	Age_Group,
	COUNT(*) AS Age_group_count,
	ROUND(CAST(COUNT(*) * 1.0 AS FLOAT) /
	(SELECT  COUNT(*) FROM [Femi].[dbo].[Alzheimers Dataset]) * 100,2) AS Age_group_percent
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Age_Group
	ORDER BY Age_group_count DESC,Age_group_percent DESC

/*3)What was the distribution of Alzheimer's disease risk in top five country having diabetes,Hypertension,family history,and genetic risk respectively?*/
With top_five_country_distribution as
(
SELECT
	Country,
	COUNT(*) AS country_count,
	DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) as count_rank
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	AND
	Diabetes = 1 AND Hypertension = 1 AND Family_History_of_Alzheimerâ_s = 1 AND Genetic_Risk_Factor_APOE_Îµ4_allele = 1
	GROUP BY Country
)
SELECT 
	Country,country_count,count_rank
	FROM
	top_five_country_distribution
	WHERE count_rank <= 5
	

--4)What was the distribution of Alzheimer's disease across different Age_Group with genetic risk and family history?
SELECT 
	Age_Group,
	COUNT(*) AS country_count,
	DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS country_rank
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes' 
	AND CASE WHEN Genetic_Risk_Factor_APOE_Îµ4_allele = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Age_Group
	ORDER BY country_count DESC

--5)How does the prevalence of Alzheimer's disease vary across different country(displaying average bmi and cognitive test score?
SELECT 
	Country,
	COUNT(*) AS contry_count,
	ROUND(AVG(BMI),2) AS average_bmi,
	AVG(cognitive_Test_Score) as average_cognitive_score
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Country
	ORDER BY contry_count DESC

--6)What was the significant differences between male and female in the dataset?
SELECT 
	Gender,
	COUNT(*) AS gender_count,
	ROUND(CAST(COUNT(*) * 1.0 AS FLOAT) /
	(SELECT  COUNT(*) FROM [Femi].[dbo].[Alzheimers Dataset])* 100,2) AS gender_percentage
	FROM [Femi].[dbo].[Alzheimers Dataset]
	-- WHERE 
	-- CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Gender
	ORDER BY gender_count DESC

--7)What was the correlation between sleep quality,average bmi and cognitive test score of Alzheimer's disease?
SELECT 
	Sleep_Quality,
	ROUND(AVG(BMI),2) AS avg_bmi,
	ROUND(AVG(cognitive_Test_Score),2) as avg_cog_test,
	COUNT(*) AS sleep_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Sleep_Quality


--8)Find the distribution employment status of developing Alzheimer's disease.
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

SELECT 
	Employment_Status, 
	COUNT(*) AS count_of_risk
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Employment_Status
	ORDER BY count_of_risk DESC

--9)How does smoking status influenced Alzheimer's disease risk?
SELECT 
	Smoking_Status,
	COUNT(*) AS count_of_status
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Smoking_Status
	ORDER BY count_of_status DESC
     
--10)What was the relationship between alcohol consumption and Alzheimer's disease risk?
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

SELECT 
	Alcohol_Consumption,
	COUNT(*) AS count_of_consumption
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Alcohol_Consumption
	ORDER BY count_of_consumption DESC

--11) What impact does family history has on Alzheimer's disease risk across respective Gender?
WITH Gender_Percentage AS
(
	SELECT 
	Gender,
	COUNT(*) AS Gender_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	AND
    CASE WHEN Family_History_of_Alzheimerâ_s = 1 THEN 'Yes' END ='Yes' 
	GROUP BY Gender)
SELECT 
	Gender,
	Gender_count,
	ROUND(CAST(Gender_count * 1.0 / SUM(Gender_count) OVER() AS FLOAT) * 100,2)  AS Gender_Percentage_Ratio
	FROM Gender_Percentage


--12)How does diabetes affect the risk of developing Alzheimer's disease for different respective country?
WITH Diabetes_country as
(
SELECT 
	Country,
	COUNT(*) AS Diabetes_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	AND
    CASE WHEN Diabetes = 1 THEN 'Yes' END ='Yes' 
	GROUP BY Country
),
percentage_rank as 
(
SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY Diabetes_count DESC) AS Diebetes_Rank,
	ROUND(CAST(Diabetes_count * 1.0 / SUM(Diabetes_count) OVER() AS FLOAT) * 100,2) AS Diabetes_Percentage
	FROM Diabetes_country
)
SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY Diabetes_Percentage DESC) AS Diabetes_Percent_Rank
	FROM percentage_rank


--13)How does marital status impact the risk of developing Alzheimer's disease?
SELECT 
	Marital_Status,
	COUNT(*) AS marital_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes' 
	GROUP BY Marital_Status
	ORDER BY marital_count DESC

--14)Does Body Mass Index(BMI) influenced prevalence of Alzheimer's disease risk across dietary habit and Genetics?
SELECT 
	Dietary_Habits,
	ROUND(AVG(BMI),2) AS average_body_mass,
	COUNT(*) AS Dietary_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	AND CASE WHEN Genetic_Risk_Factor_APOE_Îµ4_allele = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Dietary_Habits

-- 15)How does social engagement level,urban,and rural living affected Alzheimer's disease? 
WITH social_engagement as
(
SELECT 
	Social_Engagement_Level,
	Urban_vs_Rural_Living,
	COUNT(*) AS Dietary_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes' 
	GROUP BY Social_Engagement_Level,Urban_vs_Rural_Living	
)
SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY Dietary_count DESC) AS Dietary_Rank
	FROM social_engagement

/* 16)What were the average rate of education level,bmi, and cognitive test score for age group whom are alcoholic and liable to Alzheimer's disease? */
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

SELECT 
	Age_Group,
	Alcohol_Consumption,
	AVG(Education_Level) AS Average_Edu_Level,
	ROUND(AVG(BMI),2) AS Average_bmi,
	AVG(Cognitive_Test_Score) as Average_Cog_Test_Score
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Age_Group,Alcohol_Consumption
	ORDER BY Age_Group DESC,Alcohol_Consumption DESC

-- 17)What were the percentage of depression level of countries with heart Alzheimer's disease risk?
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

WITH Depression_percentage as
(
SELECT 
	Depression_Level,
	COUNT(*) AS Depression_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Depression_Level
)
SELECT
	*,
	ROUND(CAST(Depression_count * 1.0 / SUM(Depression_count) OVER() AS FLOAT) * 100,2) AS Diabetes_Percentage
    FROM Depression_percentage


-- 18)What were the average cognitive test scores rate for age group with Alzheimer's disease risk?
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

SELECT 
	Age_Group,
	AVG(Cognitive_TesT_Score) as Average_Test_score,
	COUNT(*) AS Age_Group_Count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Age_Group
	ORDER BY Age_Group_Count DESC


-- 19)What were the percentage of country with no Alzheimer's disease risk?
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

WITH percentage_of_country_with_no_alzheimer as
(
SELECT 
	Country,
	COUNT(*) AS Country_Count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 0 THEN 'No' END = 'No'
	GROUP BY Country
),
percentage_country as
(
SELECT *,
	DENSE_RANK() OVER(ORDER BY Country_Count DESC) AS count_rank,
	ROUND(CAST(Country_Count * 1.0 / SUM(Country_Count) OVER() AS FLOAT) * 100,2) AS Country_Percentage
	FROM percentage_of_country_with_no_alzheimer
)
SELECT 
	*,
	DENSE_RANK() OVER(ORDER BY Country_Percentage DESC) AS contry_percent
	FROM percentage_country






