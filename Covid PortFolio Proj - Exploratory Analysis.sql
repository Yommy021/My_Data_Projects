
SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off), MIN(total_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MAX(`date`), MIN(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;


ALTER TABLE layoffs_staging2
ADD COLUMN staff_not_laidoff int;

UPDATE layoffs_staging2
SET staff_not_laidoff = ((1 - percentage_laid_off) * (total_laid_off)) / percentage_laid_off ;

ALTER TABLE layoffs_staging2
DROP COLUMN staff_not_laidoff;

SELECT SUBSTRING(`date`, 1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 DESC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 DESC
)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

SELECT company, 
SUBSTRING(`date`, 1, 7), SUM(total_laid_off) AS total_off 
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company, SUBSTRING(`date`, 1, 7)
ORDER BY 2 DESC;




WITH company_year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_off 
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY company, YEAR(`date`)
ORDER BY 2 DESC
), Company_year_rank AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking 
FROM company_year
WHERE years IS NOT NULL
)
SELECT * FROM company_year_rank
WHERE ranking <= 5;


