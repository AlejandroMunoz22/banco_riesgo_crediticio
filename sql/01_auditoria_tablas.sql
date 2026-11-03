SELECT 
    t.name AS table_name,
    SUM(p.rows) AS total_rows
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
GROUP BY t.name
ORDER BY total_rows DESC;

SELECT COUNT(*) AS total_rows, COUNT(DISTINCT SK_ID_CURR) as total_not_duplicates, (COUNT(*) - COUNT(DISTINCT(SK_ID_CURR))) AS duplicates 
FROM application_train 

SELECT COUNT(*) AS total_row, (SUM(CAST(TARGET AS int))) AS target_people , (100 * (SUM(TARGET) / COUNT(*))) AS percentage
FROM application_train