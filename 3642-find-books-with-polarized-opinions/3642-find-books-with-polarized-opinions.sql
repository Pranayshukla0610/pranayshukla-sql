# Write your MySQL query statement below
WITH pointers AS (
    SELECT MAX(r.session_rating) AS highest_rating,
           MIN(r.session_rating) AS lowest_rating,
           COUNT(*) AS total_sessions,
           book_id,
           SUM(
            CASE 
                WHEN r.session_rating <= 2 OR r.session_rating >= 4 THEN 1 
                    ELSE 0 
                END) AS extreme_rating
    FROM reading_sessions r
    GROUP BY book_id
)
SELECT p.book_id,
       b.title,
       b.author,
       b.genre,
       b.pages,
       (p.highest_rating - p.lowest_rating) AS rating_spread,
       ROUND(p.extreme_rating * 1.0/p.total_sessions,2) AS polarization_score
FROM pointers p
JOIN books b ON p.book_id = b.book_id
WHERE total_sessions >= 5
      AND (p.extreme_rating * 1.0 / p.total_sessions) >= 0.6
      AND p.highest_rating >= 4
      AND p.lowest_rating <= 2
ORDER BY polarization_score DESC, b.title DESC 