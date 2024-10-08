select * from layoffs;

create table layoffs_staging
like layoffs;

select * from layoffs_staging;

insert layoffs_staging 
select *
 from layoffs;
 
 -- data cleaning
 
 select *,
 row_number() over(
 partition by company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
 from layoffs_staging;

-- using cte
with duplicate_cte as
(
select *,
 row_number() over(
 partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
 from layoffs_staging
)
select * 
from duplicate_cte
where row_num>1;

select * from layoffs_staging
where company='Casper';


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int default null,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2
where row_num>1;

select * from layoffs_staging2;

insert into  layoffs_staging2
select *,
 row_number() over(
 partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
 from layoffs_staging;
 
 

select * from layoffs_staging2;


-- standardising data

select company,trim(company)
from layoffs_staging2;

update layoffs_staging2
set company=trim(company);

select distinct(industry)
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where industry like 'Crypto%';


update layoffs_staging2
set industry ='Crypto'
where industry like 'Crypto%';


select distinct(location)
from layoffs_staging2
order by 1;

select distinct(country)
from layoffs_staging2
order by 1;

select * from layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM world_layoffs.layoffs_staging2;

select
`date`
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date` , '%m/%d/%Y' );

select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2
where industry is null or industry ='';


select * from layoffs_staging2
where company='Airbnb';


select * from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company= t2.company
and t1.location=t2.location
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company =t2.company
set t1.industry=t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2
set industry =null 
where industry=''; 

