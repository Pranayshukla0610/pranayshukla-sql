# Write your MySQL query statement below
WITH invalid_ips AS (
    SELECT ip
    FROM logs
    WHERE
        -- Rule 1: Not exactly 4 octets
        LENGTH(ip) - LENGTH(REPLACE(ip, '.', '')) <> 3

        OR

        -- Rule 2: Any octet > 255
        CAST(SUBSTRING_INDEX(ip, '.', 1) AS UNSIGNED) > 255
        OR CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) AS UNSIGNED) > 255
        OR CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) AS UNSIGNED) > 255
        OR CAST(SUBSTRING_INDEX(ip, '.', -1) AS UNSIGNED) > 255

        OR

        -- Rule 3: Leading zeros
        SUBSTRING_INDEX(ip, '.', 1) LIKE '0%' AND SUBSTRING_INDEX(ip, '.', 1) <> '0'
        OR SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) LIKE '0%' 
           AND SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) <> '0'
        OR SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) LIKE '0%' 
           AND SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) <> '0'
        OR SUBSTRING_INDEX(ip, '.', -1) LIKE '0%' AND SUBSTRING_INDEX(ip, '.', -1) <> '0'
)
SELECT 
    ip,
    COUNT(*) AS invalid_count
FROM invalid_ips
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;
