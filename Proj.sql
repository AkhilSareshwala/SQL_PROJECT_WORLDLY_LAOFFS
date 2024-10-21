-- DATA CLEANING
-- 1) REMOVE DUPLICATES
-- 2) STANDARDIZE DATA
-- 3) HANDLE NULL VALUES OR MISSING VALUES
-- 4) REMOVE UNWANTED ROWS AND COLUMNS

-- COPYING THE TABLE TO layoffs_1
CREATE TABLE layoffs_1 AS SELECT * FROM layoffs;

-- CREATING layoffs_2 FOR ADDING ROW_NUMBER
CREATE TABLE layoffs_2 AS 
WITH cte_duplicate AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, date, stage, funds_raised_millions) AS row_num
    FROM layoffs_1
)
SELECT * FROM cte_duplicate;

-- DELETE DUPLICATES (row_num=2 DEFINES DUPLICATES)
DELETE FROM layoffs_2 WHERE row_num = 2;

-- STANDARDIZING DATA
-- TRIM WHITESPACE FROM COLUMNS
UPDATE layoffs_2 SET company = TRIM(company);
UPDATE layoffs_2 SET country = TRIM(country);
UPDATE layoffs_2 SET industry = TRIM(industry);

-- CHANGING 'CRYPTO CURRENCY' TO 'CRYPTO' AS BOTH ARE SAME
UPDATE layoffs_2 SET industry = 'Crypto' WHERE industry LIKE '%Crypto%';

-- RENAMING 'UNITED STATES.' TO 'UNITED STATES'
UPDATE layoffs_2 SET country = 'United States' WHERE country LIKE '%United States%';

-- ALTERING DATA TYPE OF DATE TO DATE FROM VARCHAR IN MM/DD/YYYY FORMAT
ALTER TABLE layoffs_2
ALTER COLUMN date TYPE DATE 
USING to_date(date, 'MM/DD/YYYY');

-- HANDLING NULL VALUES
-- FILLING INDUSTRY NULL VALUES BY FETCHING FROM DIFFERENT ROW WHERE COMPANY IS SAME AND INDUSTRY IS NOT NULL
UPDATE layoffs_2 e2
SET industry = (
    SELECT e1.industry
    FROM layoffs_2 e1
    WHERE e1.company = e2.company AND e1.industry IS NOT NULL
)
WHERE e2.industry IS NULL OR e2.industry = '';

-- CHECK FOR REMAINING NULL VALUES IN INDUSTRY
SELECT * FROM layoffs_2 WHERE industry IS NULL OR industry = '';

-- REMOVING UNWANTED ROWS AND COLUMNS
DELETE FROM layoffs_2 WHERE total_laid_off IS NULL;
DELETE FROM layoffs_2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
ALTER TABLE layoffs_2 DROP COLUMN row_num;

-- EXPLORATORY DATA ANALYSIS
SELECT * FROM layoffs_2;

-- 100% LAYOFFS
ALTER TABLE layoffs_2 
ALTER COLUMN percentage_laid_off TYPE NUMERIC USING percentage_laid_off::numeric;
SELECT * FROM layoffs_2 WHERE percentage_laid_off = 1;

-- MAX EMPLOYEES LAID OFF FROM A COMPANY, INDUSTRY, COUNTRY (GROUP BY)
ALTER TABLE layoffs_2 
ALTER COLUMN total_laid_off TYPE NUMERIC USING total_laid_off::numeric;
SELECT company, SUM(total_laid_off) AS total_laid 
FROM layoffs_2 
GROUP BY company 
ORDER BY total_laid DESC;

SELECT industry, SUM(total_laid_off) AS total_laid 
FROM layoffs_2 
GROUP BY industry 
ORDER BY total_laid DESC;

SELECT country, SUM(total_laid_off) AS total_laid 
FROM layoffs_2 
GROUP BY country 
ORDER BY total_laid DESC;

-- BY DATE ANALYSIS
SELECT MIN(date), MAX(date) FROM layoffs_2;
SELECT EXTRACT(YEAR FROM date) AS year, SUM(total_laid_off) AS lays 
FROM layoffs_2 
GROUP BY year 
ORDER BY lays DESC;

-- ROLLING SUM BY YEAR AND MONTH
WITH cte_roll_by_year AS (
    SELECT EXTRACT(YEAR FROM date) AS year,
           EXTRACT(MONTH FROM date) AS month,
           SUM(total_laid_off) AS total  
    FROM layoffs_2 
    WHERE total_laid_off IS NOT NULL 
    GROUP BY year, month 
    ORDER BY year, month
)
SELECT year, month, total, 
       SUM(total) OVER (ORDER BY year, month) AS rolling_total 
FROM cte_roll_by_year;

-- YEARLY COMPANY LAYOFFS
WITH cte_rank AS (
    SELECT company, 
           EXTRACT(YEAR FROM date) AS year,
           SUM(total_laid_off) AS total 
    FROM layoffs_2 
    WHERE total_laid_off IS NOT NULL 
    GROUP BY company, year 
    ORDER BY total
)
SELECT *, 
       DENSE_RANK() OVER (PARTITION BY year ORDER BY total DESC) AS rank 
FROM cte_rank;
