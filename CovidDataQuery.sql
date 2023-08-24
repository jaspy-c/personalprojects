SELECT *
FROM Portfolio..covid_data
WHERE continent is not null
ORDER BY 3,4

--Filling Blanks as NULL in the Continent Column
UPDATE Portfolio..covid_data
SET Continent = NULLIF(Continent,'')

--Total Cases, Total Deaths, Percentage of Death Worldwide
SELECT SUM(CAST(new_cases as float)) as final_total_cases, SUM(CAST(new_deaths as float)) as final_total_deaths, ROUND(SUM(CAST(new_deaths as float))/ NULLIF(SUM(CAST(new_cases as float)),0)*100, 3) as DeathPercentage
FROM Portfolio..covid_data
WHERE continent is not NULL
ORDER BY 1

--Total Death Count by Continent
SELECT location, SUM(CAST(new_deaths as float)) as Total_Death_Count
FROM Portfolio..covid_data
WHERE continent is null and location not in ('World', 'European Union', 'International', 'High Income', 'Upper middle income', 'lower middle income', 'low income')
GROUP BY location
ORDER BY Total_Death_Count DESC

--Looking at Total Cases vs Total Deaths in the United States
SELECT date, total_cases, total_deaths, ROUND((CAST(total_deaths as float)/ NULLIF(CAST(total_cases as float),0)*100), 3) as DeathPercentage
FROM Portfolio..covid_data
WHERE location = 'United States'
ORDER BY 1

--Looking at Total Cases vs Population in the United States
SELECT Location, date, Population, total_cases, ROUND((CAST(total_deaths as float)/ NULLIF(CAST(population as float),0)*100), 5) as InfectedPercentage
FROM Portfolio..covid_data
WHERE location = 'United States'
ORDER BY 2

--Looking at Countries with Highest Infection Rate Compared to Population
SELECT Location, Population, MAX(CAST(total_cases as float)) as HighestInfectionCount, ROUND(MAX(CAST(total_cases as float)/ CAST(Population as float)*100), 3) as PercentPopulationInfected
FROM Portfolio..covid_data
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


SELECT Location, Population, date, MAX(CAST(total_cases as float)) as HighestInfectionCount, ROUND(MAX(CAST(total_cases as float)/ CAST(Population as float)*100), 3) as PercentPopulationInfected
FROM Portfolio..covid_data
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC
