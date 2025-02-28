# Alzheimers-Portfolio-Project


### Table of contents

-----------------------


- [Project Overview](#Project_Overview)

This comprehensive analysis explores the complex relationships between various risk factors and Alzheimer's disease. The project examines 74,283 records dataset, spanning 20 countries, revealing intriguing insights into the demographics, lifestyle, and health factors influencing Alzheimer's disease risk.

**Key Findings**
- Alzheimer's disease risk increases with age, with significant variations across countries and demographics.
- Diabetes, hypertension, family history, and genetic risk are prominent factors contributing to Alzheimer's disease risk.
- Lifestyle factors such as sleep quality, physical activity, and social engagement also play a crucial role in determining Alzheimer's disease risk.
- Education level, BMI, and cognitive test scores are correlated with Alzheimer's disease risk, particularly in individuals with a history of alcohol consumption.
  


- [Data Source](#Data_Source)

The primary dataset utilized for the project can be downloaded from the provided link [https://www.kaggle.com/datasets/ankushpanday1/alzheimers-prediction-dataset-global](https://www.kaggle.com/datasets/ankushpanday1/alzheimers-prediction-dataset-global)


  
- [Tools](#Tools)

Python libraries utilized:

- Pandas for data manipulation and analysis
- Matplotlib and Seaborn for data visualization
- NumPy for numerical computations
  
- [Data Preprocessing](#Data_Preprocessing )
  
Data preprocessing steps:
- Data cleaning and preprocessing
- Creation of a new column "Age_Group" to  categorize ages in the dataset
- Checked and handled missing values
- Removing Duplicate values


### Data Analysis
Below were the codes utilised.

```
--Inspecting dataset to check data quality and completeness.
-- 74,283 dataset.
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

```

```
-- Inspect each respective columns,To comprehend the dataset.
-- low,high,medium.
SELECT
	DISTINCT(Physical_Activity_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Current,Former,Never.
SELECT
	DISTINCT(Smoking_Status)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Regularly,Occasionally,Never
SELECT
	DISTINCT(Alcohol_Consumption)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Normal,High.
SELECT
	DISTINCT(Cholesterol_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- High,Medium,Low.
SELECT
	DISTINCT(Depression_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

-- Good,Poor,Average.
SELECT
	DISTINCT(Sleep_Quality)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Unhealthy,Healthy,Average.
SELECT
	DISTINCT(Dietary_Habits)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Low,High,Medium
SELECT
	DISTINCT(Air_Pollution_Exposure)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Retired,Employed,Unemployed.
SELECT
	DISTINCT(Employment_Status)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Single,Widowed,Married.
SELECT
	DISTINCT(Marital_Status)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Low,High,Medium.
SELECT
	DISTINCT(Social_Engagement_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Low,High,Medium.
SELECT
	DISTINCT(Income_Level)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```
-- Low,High,Medium.
SELECT
	DISTINCT(Stress_Levels)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Urban,Rural.
SELECT
	DISTINCT(Urban_vs_Rural_Living)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Quinquagenarians,Septuagenarians,Nonagenarians,Sexagenarians.
SELECT
	DISTINCT(Age_Group)
	FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

-- Datatypes Overview.
EXEC sp_columns [Alzheimers Dataset]

```

```
-- I created a new column 'Age_Group'.
ALTER TABLE [Alzheimers Dataset]
ADD Age_Group VARCHAR(30)

```

```

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

```

```

-- Explanatory Data Analysis.

--1)What was the total number of countries in the dataset?
SELECT 
	 Count(DISTINCT Country) AS Total_Countries 
	 FROM [Femi].[dbo].[Alzheimers Dataset]

```

```

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

```

```

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
	
```

```
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

```

```

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

```

```

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

```

```

--7)What was the correlation between sleep quality,average bmi and cognitive test score of Alzheimer's disease?
SELECT 
	Sleep_Quality,
	ROUND(AVG(BMI),2) AS avg_bmi,
	ROUND(AVG(cognitive_Test_Score),2) as avg_cog_test,
	COUNT(*) AS sleep_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Sleep_Quality

```

```

--8)Find the distribution employment status of developing Alzheimer's disease.
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

SELECT 
	Employment_Status, 
	COUNT(*) AS count_of_risk
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Employment_Status
	ORDER BY count_of_risk DESC

```

```

--9)How does smoking status influenced Alzheimer's disease risk?
SELECT 
	Smoking_Status,
	COUNT(*) AS count_of_status
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Smoking_Status
	ORDER BY count_of_status DESC

```

```
     
--10)What was the relationship between alcohol consumption and Alzheimer's disease risk?
SELECT * FROM [Femi].[dbo].[Alzheimers Dataset]

SELECT 
	Alcohol_Consumption,
	COUNT(*) AS count_of_consumption
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes'
	GROUP BY Alcohol_Consumption
	ORDER BY count_of_consumption DESC

```

```

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

```

```

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

```

```

--13)How does marital status impact the risk of developing Alzheimer's disease?
SELECT 
	Marital_Status,
	COUNT(*) AS marital_count
	FROM [Femi].[dbo].[Alzheimers Dataset]
	WHERE 
	CASE WHEN Alzheimerâ_s_Diagnosis = 1 THEN 'Yes' END = 'Yes' 
	GROUP BY Marital_Status
	ORDER BY marital_count DESC

```

```

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

```

```

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

```

```

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


```

```

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

```

```

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

```

```

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

```











- [Explanatory Data Analysis](#Explanatory_Data_Analysis)

The EDA phase aimed to uncover patterns, relationships, and insights from the dataset. The following key findings emerged:

1.  What was the total number of countries in the dataset?
2.  How does Alzheimer's disease risk vary by age group?
3.  What was the distribution of Alzheimer's disease risk in top five country having diabetes, Hypertension, family history, and genetic risk respectively?
4.  What was the distribution of Alzheimer's disease across different age group with genetic risk and family history?
5.  How does the prevalence of Alzheimer's disease vary across different country displaying average BMI, and cognitive test score?
6.  What was the significant differences between male and female in the dataset?
7.  What was the correlation between sleep quality, average BMI, and cognitive test score of Alzheimer's disease?
8.  Find the distribution employment status of developing Alzheimer's disease.
9.  How does smoking status influenced Alzheimer’s disease risk?
10.  What was the relationship between alcohol consumption and Alzheimer's disease risk?
11.  What impact does family history has on Alzheimer's disease risk across respective gender?
12.  How does diabetes affect the risk of developing Alzheimer's disease for different respective country?
13. How does Body Mass Index (BMI) influenced prevalence of Alzheimer's disease risk across dietary habit and Genetics?
14.  How does social engagement level, urban, and rural living affected Alzheimer's disease?
15.  What were the average rate of education level, BMI, and cognitive test score for age group whom are alcoholic and liable to Alzheimer's disease?
16.  What were the percentage of depression level of countries with heart Alzheimer's disease risk?
17.  What were the average cognitive test scores rate for age group with Alzheimer's disease risk?
18.  What were the percentage of country with no Alzheimer's disease risk?
19.  What were the percentage of country with no Alzheimer's disease risk?


- [Results/Findings](#Results/Findings)
 
This comprehensive analysis explores the complex relationships between various risk factors and Alzheimer's disease, utilizing a dataset spanning 20 countries.

#### Key Demographic Findings
- Octogenarians (80-89 years) had the highest distribution of Alzheimer's disease risk (14.7%).
- Females (50.14%) outnumbered males (49.86%) in the dataset.
- Retired individuals were more susceptible to Alzheimer's disease.

#### Risk Factors and Correlations
- Diabetes, hypertension, family history, and genetic risk were prominent factors contributing to Alzheimer's disease risk.
- Sleep quality, physical activity, and social engagement played crucial roles in determining Alzheimer's disease risk.
- Genetic risk and family history were significant factors in Alzheimer's disease risk across different age groups.

#### Country-Specific Findings
- Russia had the highest prevalence of Alzheimer's disease, while Sweden had the lowest.
- Diabetes affected Alzheimer's disease risk differently across countries, with Russia having the highest risk (6.65%) and Canada having the lowest risk (3.84%).

#### Lifestyle and Health Factors
- Marital status impacted Alzheimer's disease risk, with single individuals being more susceptible.
- Dietary habits, social engagement levels, and urban/rural living environments influenced Alzheimer's disease risk.
- Smoking status and alcohol consumption also varied in their relationships with Alzheimer's disease risk.

#### Cognitive Test Scores and Education Levels
- Average cognitive test scores varied across age groups, with octogenarians having the lowest score (64).
- Education levels and BMI were correlated with Alzheimer's disease risk in individuals with a history of alcohol consumption.

#### epression Levels and Countries with No Alzheimer's Disease Diagnosis
- Depression levels varied across countries, with low, medium, and high levels observed.
- Japan had the highest percentage of individuals with no Alzheimer's disease diagnosis (5.69%), while Mexico had the lowest percentage (4.26%).

  
- [Recommendation](#Recommendation)

#### Demographic Considerations
1. _Targeted interventions_: Focus on octogenarians (80-89 years) and females, who are disproportionately affected by Alzheimer's disease.
2. _Retiree support_: Provide resources and support for retired individuals to mitigate Alzheimer's disease risk.
3. _Family support_: Offer support and resources for families with a history of Alzheimer's disease.

 #### Risk Factor Mitigation
4.Diabetes management: Implement effective diabetes management strategies to reduce Alzheimer's disease risk.
5.Healthy lifestyle promotion: Encourage physical activity, social engagement, and healthy sleep habits to reduce Alzheimer's disease risk.
6.Hypertension management: Develop strategies to manage hypertension and reduce Alzheimer's disease risk.

#### Country-Specific Initiatives
7.Russia and Canada: Develop targeted interventions for Russia (high-risk) and Canada (low-risk) to address diabetes-related Alzheimer's disease risk.
8.Sweden: Investigate factors contributing to Sweden's low Alzheimer's disease prevalence.
9.Mexico: Implement initiatives to address Mexico's low percentage of individuals with no Alzheimer's disease diagnosis.

#### Healthcare System Enhancements
10.Early detection and diagnosis: Improve early detection and diagnosis of Alzheimer's disease, particularly in high-risk groups.
11.Personalized care: Develop personalized care plans addressing individual risk factors, lifestyle, and health conditions.
12.Interdisciplinary care teams: Establish interdisciplinary care teams to provide comprehensive care for individuals with Alzheimer's disease.

#### Public Health Awareness
13.Education and awareness: Launch public awareness campaigns highlighting Alzheimer's disease risk factors, prevention strategies, and available resources.
14.Support networks: Establish support networks for individuals with Alzheimer's disease, caregivers, and families.
15.Community engagement: Encourage community engagement and participation in Alzheimer's disease research and awareness initiatives.

#### Research and Development
16. _Genetic research_: Conduct further research on genetic risk factors for Alzheimer's disease.
17. _Lifestyle intervention studies_: Conduct studies on the effectiveness of lifestyle interventions in reducing Alzheimer's disease risk.
18. _Biomarker development_: Develop biomarkers for early detection and diagnosis of Alzheimer's disease.

#### Policy and Advocacy
19. _Policy development_: Develop policies addressing Alzheimer's disease risk factors, prevention strategies, and care services.
20. _Advocacy efforts_: Support advocacy efforts promoting awareness, research, and support for individuals with Alzheimer's disease and their families.
