SELECT *
FROM application_train

SELECT COUNT(*) as total_applications, SUM(CASE WHEN TARGET = 1 THEN 1 END) AS num_target_one, ROUND(100.00 * SUM(CASE WHEN TARGET = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) as default_rate_pct
FROM application_train

SELECT NAME_CONTRACT_TYPE, COUNT(*) AS total_people, SUM(CASE WHEN TARGET = 1 THEN 1 else 0 END) as total_defaults, ROUND(100.0 * SUM(CASE WHEN TARGET = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) as default_rate_pct, ROUND(AVG(AMT_CREDIT), 0) AS avg_amt_credit
FROM application_train
GROUP BY NAME_CONTRACT_TYPE
ORDER BY default_rate_pct DESC;

SELECT NAME_INCOME_TYPE, COUNT(*) AS total_applications, SUM(CASE WHEN TARGET = 1 THEN 1 ELSE 0 END) AS total_defaults, ROUND(100.0 *SUM(CASE WHEN TARGET = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct, AVG(AMT_INCOME_TOTAL) as avg_income
FROM application_train
GROUP BY NAME_INCOME_TYPE
HAVING COUNT(*) > 1000
ORDER BY default_rate_pct DESC;

WITH application_laverage AS(
SELECT  
    CASE
        WHEN AMT_CREDIT / AMT_INCOME_TOTAL < 2.0 THEN '1. low_average'
        WHEN AMT_CREDIT / AMT_INCOME_TOTAL >= 2.0 AND AMT_CREDIT / AMT_INCOME_TOTAL <= 4.0 THEN '2. moderate_laverage'
        WHEN AMT_CREDIT / AMT_INCOME_TOTAL > 4.0 AND AMT_CREDIT / AMT_INCOME_TOTAL <= 6.0 THEN '3. high_laverage'
        ELSE '4. extreme_laverage'
    END AS leverage_segment,
    TARGET, 
    DAYS_BIRTH
FROM dbo.application_train
)
SELECT 
    leverage_segment,
    COUNT(*) AS total_applications,
    ROUND(100.0 * SUM(CASE WHEN TARGET = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(-1.0 * DAYS_BIRTH / 365.25), 1) AS avg_age_years
FROM application_laverage
GROUP BY leverage_segment
ORDER BY leverage_segment ASC


