##########################################################
# This SQL script imports datasets (CSV files) with MySQL
# and creates tables.
##########################################################



####   Error Code: 3948   ####
# If "Error Code: 3948" occurs when loading dataset, run the two following lines of codes
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile=1;



-- Create a database
CREATE DATABASE IF NOT EXISTS covid;

-- Create CovidDeaths table
CREATE TABLE covid.deaths
(
	iso_code VARCHAR(50) DEFAULT NULL, 
	continent VARCHAR(50) DEFAULT NULL, 
	location VARCHAR(50) DEFAULT NULL, 
	infection_date VARCHAR(10) DEFAULT NULL, 
	population INT DEFAULT NULL, 
	total_cases INT DEFAULT NULL, 
	new_cases INT DEFAULT NULL, 
	new_cases_smoothed DOUBLE DEFAULT NULL, 
	total_deaths INT DEFAULT NULL, 
	new_deaths INT DEFAULT NULL, 
	new_deaths_smoothed DOUBLE DEFAULT NULL, 
	total_cases_per_million DOUBLE DEFAULT NULL, 
	new_cases_per_million DOUBLE DEFAULT NULL, 
	new_cases_smoothed_per_million DOUBLE DEFAULT NULL, 
	total_deaths_per_million DOUBLE DEFAULT NULL, 
	new_deaths_per_million DOUBLE DEFAULT NULL, 
	new_deaths_smoothed_per_million DOUBLE DEFAULT NULL, 
	reproduction_rate DOUBLE DEFAULT NULL, 
	icu_patients INT DEFAULT NULL, 
	icu_patients_per_million DOUBLE DEFAULT NULL, 
	hosp_patients INT DEFAULT NULL, 
	hosp_patients_per_million DOUBLE DEFAULT NULL, 
	weekly_icu_admissions INT DEFAULT NULL, 
	weekly_icu_admissions_per_million DOUBLE DEFAULT NULL, 
	weekly_hosp_admissions INT DEFAULT NULL, 
	weekly_hosp_admissions_per_million DOUBLE DEFAULT NULL
);

-- Populate the table with CovidDeaths.csv file
load data local infile '/ProgramData/MySQL/MySQL Server 8.0/Uploads/Covid19/CovidDeaths.csv'
into table covid.deaths
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(iso_code, @vcontinent, @vlocation, infection_date, @vpopulation, @vtotal_cases, @vnew_cases, @vnew_cases_smoothed, @vtotal_deaths, @vnew_deaths, 
@vnew_deaths_smoothed, @vtotal_cases_per_million, @vnew_cases_per_million, @vnew_cases_smoothed_per_million, @vtotal_deaths_per_million,  
@vnew_deaths_per_million, @vnew_deaths_smoothed_per_million, @vreproduction_rate, @vicu_patients, @vicu_patients_per_million,  
@vhosp_patients, @vhosp_patients_per_million, @vweekly_icu_admissions, @vweekly_icu_admissions_per_million, @vweekly_hosp_admissions,  
@vweekly_hosp_admissions_per_million)
SET
	# Keep NULL values when loading CSV
	continent = NULLIF(@vcontinent, ''),
	location = NULLIF(@vlocation, ''),
	population   = NULLIF(@vpopulation, ''),
	total_cases  = NULLIF(@vtotal_cases, ''),
	new_cases  = NULLIF(@vnew_cases, ''),
	new_cases_smoothed  = NULLIF(@vnew_cases_smoothed, ''),
	total_deaths = NULLIF(@vtotal_deaths, ''),
	new_deaths  = NULLIF(@vnew_deaths, ''),
	new_deaths_smoothed  = NULLIF(@vnew_deaths_smoothed, ''),
	total_cases_per_million  = NULLIF(@vtotal_cases_per_million, ''),
	new_cases_per_million = NULLIF(@vnew_cases_per_million, ''),
	new_cases_smoothed_per_million = NULLIF(@vnew_cases_smoothed_per_million, ''),
	total_deaths_per_million = NULLIF(@vtotal_deaths_per_million, ''),
	new_deaths_per_million = NULLIF(@vnew_deaths_per_million, ''),
	new_deaths_smoothed_per_million = NULLIF(@vnew_deaths_smoothed_per_million, ''),
	reproduction_rate = NULLIF(@vreproduction_rate, ''), 
	icu_patients = NULLIF(@vicu_patients, ''),  
	icu_patients_per_million = NULLIF(@vicu_patients_per_million, ''),  
	hosp_patients = NULLIF(@vhosp_patients, ''),  
	hosp_patients_per_million = NULLIF(@vhosp_patients_per_million, ''),  
	weekly_icu_admissions = NULLIF(@vweekly_icu_admissions, ''),  
	weekly_icu_admissions_per_million = NULLIF(@vweekly_icu_admissions_per_million, ''),  
	weekly_hosp_admissions = NULLIF(@vweekly_hosp_admissions, ''),  
	weekly_hosp_admissions_per_million = NULLIF(@vweekly_hosp_admissions_per_million, '');


-- Create CovidVacciations table
CREATE TABLE covid.vaccinations
(
	iso_code VARCHAR(50) DEFAULT NULL, 
	continent VARCHAR(50) DEFAULT NULL, 
	location VARCHAR(50) DEFAULT NULL, 
	infection_date VARCHAR(10) DEFAULT NULL,  
	total_tests INT DEFAULT NULL, 
	new_tests INT DEFAULT NULL,
	total_tests_per_thousand DOUBLE DEFAULT NULL,  
	new_tests_per_thousand DOUBLE DEFAULT NULL,   
	new_tests_smoothed DOUBLE DEFAULT NULL,  
	new_tests_smoothed_per_thousand DOUBLE DEFAULT NULL,  
	positive_rate DOUBLE DEFAULT NULL,  
	tests_per_case DOUBLE DEFAULT NULL,  
	tests_units VARCHAR(225) DEFAULT NULL, 
	total_vaccinations INT DEFAULT NULL, 
	people_vaccinated INT DEFAULT NULL, 
	people_fully_vaccinated INT DEFAULT NULL, 
	total_boosters INT DEFAULT NULL, 
	new_vaccinations INT DEFAULT NULL, 
	new_vaccinations_smoothed DOUBLE DEFAULT NULL,  
	total_vaccinations_per_hundred DOUBLE DEFAULT NULL,  
	people_vaccinated_per_hundred DOUBLE DEFAULT NULL,  
	people_fully_vaccinated_per_hundred DOUBLE DEFAULT NULL,  
	total_boosters_per_hundred DOUBLE DEFAULT NULL,  
	new_vaccinations_smoothed_per_million DOUBLE DEFAULT NULL,  
	new_people_vaccinated_smoothed DOUBLE DEFAULT NULL,  
	new_people_vaccinated_smoothed_per_hundred DOUBLE DEFAULT NULL,  
	stringency_index DOUBLE DEFAULT NULL,  
	population_density DOUBLE DEFAULT NULL,  
	median_age DOUBLE DEFAULT NULL,  
	aged_65_older DOUBLE DEFAULT NULL,  
	aged_70_older DOUBLE DEFAULT NULL,  
	gdp_per_capita DOUBLE DEFAULT NULL,  
	extreme_poverty FLOAT DEFAULT NULL, 
	cardiovasc_death_rate DOUBLE DEFAULT NULL,  
	diabetes_prevalence DOUBLE DEFAULT NULL,  
	female_smokers FLOAT DEFAULT NULL, 
	male_smokers FLOAT DEFAULT NULL,
	handwashing_facilities DOUBLE DEFAULT NULL,  
	hospital_beds_per_thousand DOUBLE DEFAULT NULL,  
	life_expectancy DOUBLE DEFAULT NULL,  
	human_development_index DOUBLE DEFAULT NULL,  
	excess_mortality_cumulative_absolute DOUBLE DEFAULT NULL,  
	excess_mortality_cumulative DOUBLE DEFAULT NULL,  
	excess_mortality DOUBLE DEFAULT NULL, 
	excess_mortality_cumulative_per_million DOUBLE DEFAULT NULL
);

-- Populate the table with CovidVacciations.csv file
load data local infile '/ProgramData/MySQL/MySQL Server 8.0/Uploads/Covid19/CovidVaccinations.csv'
into table covid.vaccinations
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(iso_code, @vcontinent, @vlocation, infection_date, @vtotal_tests, @vnew_tests, @vtotal_tests_per_thousand, @vnew_tests_per_thousand,  
@vnew_tests_smoothed, @vnew_tests_smoothed_per_thousand, @vpositive_rate, @vtests_per_case, @vtests_units, @vtotal_vaccinations,  
@vpeople_vaccinated, @vpeople_fully_vaccinated, @vtotal_boosters, @vnew_vaccinations, @vnew_vaccinations_smoothed,  
@vtotal_vaccinations_per_hundred, @vpeople_vaccinated_per_hundred, @vpeople_fully_vaccinated_per_hundred, @vtotal_boosters_per_hundred,  
@vnew_vaccinations_smoothed_per_million, @vnew_people_vaccinated_smoothed, @vnew_people_vaccinated_smoothed_per_hundred, 
@vstringency_index, @vpopulation_density, @vmedian_age, @vaged_65_older, @vaged_70_older, @vgdp_per_capita, @vextreme_poverty,  
@vcardiovasc_death_rate, @vdiabetes_prevalence, @vfemale_smokers, @vmale_smokers, @vhandwashing_facilities, @vhospital_beds_per_thousand,  
@vlife_expectancy, @vhuman_development_index, @vexcess_mortality_cumulative_absolute, @vexcess_mortality_cumulative, @vexcess_mortality,  
@vexcess_mortality_cumulative_per_million)
SET
	# Keep NULL values when loading CSV
	continent = NULLIF(@vcontinent, ''),
	location = NULLIF(@vlocation, ''),  
	total_tests = NULLIF(@vtotal_tests, ''),  
	new_tests = NULLIF(@vnew_tests, ''),  
	total_tests_per_thousand = NULLIF(@vtotal_tests_per_thousand, ''),  
	new_tests_per_thousand = NULLIF(@vnew_tests_per_thousand, ''),  
	new_tests_smoothed = NULLIF(@vnew_tests_smoothed, ''),  
	new_tests_smoothed_per_thousand = NULLIF(@vnew_tests_smoothed_per_thousand, ''),  
	positive_rate = NULLIF(@vpositive_rate, ''),  
	tests_per_case = NULLIF(@vtests_per_case, ''),  
	tests_units = NULLIF(@vtests_units, ''),  
	total_vaccinations = NULLIF(@vtotal_vaccinations, ''),  
	people_vaccinated = NULLIF(@vpeople_vaccinated, ''),  
	people_fully_vaccinated = NULLIF(@vpeople_fully_vaccinated, ''),  
	total_boosters = NULLIF(@vtotal_boosters, ''),  
	new_vaccinations = NULLIF(@vnew_vaccinations, ''),  
	new_vaccinations_smoothed = NULLIF(@vnew_vaccinations_smoothed, ''),  
	total_vaccinations_per_hundred = NULLIF(@vtotal_vaccinations_per_hundred, ''),  
	people_vaccinated_per_hundred = NULLIF(@vpeople_vaccinated_per_hundred, ''),  
	people_fully_vaccinated_per_hundred = NULLIF(@vpeople_fully_vaccinated_per_hundred, ''),  
	total_boosters_per_hundred = NULLIF(@vtotal_boosters_per_hundred, ''),  
	new_vaccinations_smoothed_per_million = NULLIF(@vnew_vaccinations_smoothed_per_million, ''),  
	new_people_vaccinated_smoothed = NULLIF(@vnew_people_vaccinated_smoothed, ''),  
	new_people_vaccinated_smoothed_per_hundred = NULLIF(@vnew_people_vaccinated_smoothed_per_hundred, ''),  
	stringency_index = NULLIF(@vstringency_index, ''),  
	population_density = NULLIF(@vpopulation_density, ''),  
	median_age = NULLIF(@vmedian_age, ''),  
	aged_65_older = NULLIF(@vaged_65_older, ''),  
	aged_70_older = NULLIF(@vaged_70_older, ''),  
	gdp_per_capita = NULLIF(@vgdp_per_capita, ''),  
	extreme_poverty = NULLIF(@vextreme_poverty, ''),  
	cardiovasc_death_rate = NULLIF(@vcardiovasc_death_rate, ''),  
	diabetes_prevalence = NULLIF(@vdiabetes_prevalence, ''),  
	female_smokers = NULLIF(@vfemale_smokers, ''),  
	male_smokers = NULLIF(@vmale_smokers, ''),  
	handwashing_facilities = NULLIF(@vhandwashing_facilities, ''),  
	hospital_beds_per_thousand = NULLIF(@vhospital_beds_per_thousand, ''),  
	life_expectancy = NULLIF(@vlife_expectancy, ''),  
	human_development_index = NULLIF(@vhuman_development_index, ''),  
	excess_mortality_cumulative_absolute = NULLIF(@vexcess_mortality_cumulative_absolute, ''),  
	excess_mortality_cumulative = NULLIF(@vexcess_mortality_cumulative, ''),  
	excess_mortality = NULLIF(@vexcess_mortality, ''),  
	excess_mortality_cumulative_per_million = NULLIF(@vexcess_mortality_cumulative_per_million, '');


##########################################################
# Convert VARCHAR type of the "infection_date" column to DATE type
# Table being updated: covid.deaths
##########################################################
ALTER TABLE covid.deaths
ADD COLUMN date DATE after location;

UPDATE covid.deaths
SET date = STR_TO_DATE(infection_date, '%m/%d/%Y');

ALTER TABLE covid.deaths
DROP COLUMN infection_date;

SELECT * FROM covid.deaths;

##########################################################
# Convert VARCHAR type of the "infection_date" column to DATE type
# Table being updated: covid.vaccinations
##########################################################

ALTER TABLE covid.vaccinations
ADD COLUMN date DATE after location;

UPDATE covid.vaccinations
SET date = STR_TO_DATE(infection_date, '%m/%d/%Y');

ALTER TABLE covid.vaccinations
DROP COLUMN infection_date;

SELECT * FROM covid.vaccinations;


##########################################################
# Save updates
##########################################################
COMMIT;



