##########################################################
# This SQL script is about Covid 19 Data Exploration 
# Skills: JOIN, Window Function, CTE, TEMP TABLE, VIEW
##########################################################

-- Use covid database
USE covid;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM deaths
WHERE continent IS NOT NULL
ORDER BY location, date ASC;

##########################################################
# 1. DATA EXPLORATION BY LOCATION

-- Compare Total Cases vs Total Deaths Numbers
-- Find the proportion of deaths per location
SELECT 
	location, 
    date, 
    total_cases, 
    total_deaths, 
	ROUND((total_deaths/total_cases)*100, 2) as DeathPercentage
FROM deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Compare Total Cases vs Population
-- Find the Covid infection rate per location
SELECT 
	location, 
    date, 
    total_cases,
    population,
	ROUND((total_cases/population)*100, 2) as 'InfectionRate %'
FROM deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;

-- Find the countries with the highest infection rate compared to population
SELECT 
	location,
    population,
    MAX(total_cases) as HighestInfectionCount,
    MAX(total_cases/population)*100 as PopulationInfectedRate
FROM deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PopulationInfectedRate DESC;

-- Find the countries with daily highest infection rate compared to population 
SELECT 
	location,
    date,
    population,
    MAX(total_cases) as HighestInfectionCount,
    MAX(total_cases/population)*100 as PopulationInfectedRate
FROM deaths
WHERE continent IS NOT NULL
GROUP BY location, population, date
ORDER BY PopulationInfectedRate DESC;

-- Find the countries with the highest number of deaths per population
SELECT 
	location,
    MAX(total_deaths) as TotalDeathCount
FROM deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC;


##########################################################
# 2. DATA EXPLORATION BY Continent

-- Find the highest number of deaths per population by CONTINENT
SELECT 
	location,
    MAX(total_deaths) as TotalDeathCount
FROM deaths
WHERE 
	continent IS NULL 
    AND location NOT IN ('World', 'European Union') 
    AND location NOT LIKE "%income%"
GROUP BY location
ORDER BY TotalDeathCount DESC;						

SELECT 
	continent,
    MAX(total_deaths) as TotalDeathCount
FROM deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


##########################################################
# 3. DATA EXPLORATION ACROSS THE WORLD

-- Find the Covid New Cases across the World
SELECT 
    date, 
    SUM(new_cases) as TotalCases,
    SUM(new_deaths) as TotalDeaths,
    ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) as DeathPercentage
FROM deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

SELECT  
    SUM(new_cases) as TotalCases,
    SUM(new_deaths) as TotalDeaths,
    ROUND(SUM(new_deaths)/SUM(new_cases)*100, 2) AS DeathPercentage
FROM deaths
WHERE continent IS NOT NULL
ORDER BY 1,2;


##########################################################
# 4. JOIN Tables
    
-- Compare Total Population vs Vaccination
-- Use Window Function
SELECT 
	dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER w as CummulativeVaccinations 
FROM deaths dea
JOIN vaccinations vac ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
WINDOW w AS (Partition by dea.location ORDER BY dea.location, dea.date)
ORDER BY 2,3;


-- USE CTE
WITH POPVSVAC (continent, location, date, population, new_vaccinations, CummulativeVaccinations) 
AS (SELECT 
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(vac.new_vaccinations) OVER w as CummulativeVaccinations 
	FROM deaths dea
	JOIN vaccinations vac ON dea.location = vac.location and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	WINDOW w AS (Partition by dea.location ORDER BY dea.location, dea.date)
)
SELECT *, (CummulativeVaccinations/population)*100 as PercentVaccinatedPeople
FROM POPVSVAC;


-- Use TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
WITH POPVSVAC (continent, location, date, population, new_vaccinations, CummulativeVaccinations) 
AS (SELECT 
		dea.continent,
		dea.location,
		dea.date,
		dea.population,
		vac.new_vaccinations,
		SUM(vac.new_vaccinations) OVER w as CummulativeVaccinations 
	FROM deaths dea
	JOIN vaccinations vac ON dea.location = vac.location and dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	WINDOW w AS (Partition by dea.location ORDER BY dea.location, dea.date)
)
SELECT *, (CummulativeVaccinations/population)*100 as PercentVaccinatedPeople
FROM POPVSVAC;

SELECT * FROM PercentPopulationVaccinated;


-- CREATE View to store data for later visualization
CREATE OR REPLACE VIEW v_PopulationVaccinated AS 
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER w as CummulativeVaccinations 
FROM deaths dea
JOIN vaccinations vac ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
WINDOW w AS (Partition by dea.location ORDER BY dea.location, dea.date);

SELECT * FROM v_PopulationVaccinated;

