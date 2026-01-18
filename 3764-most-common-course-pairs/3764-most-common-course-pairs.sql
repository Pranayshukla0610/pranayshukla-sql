# Write your MySQL query statement below
WITH top_performer AS (
    SELECT user_id
    FROM course_completions
    GROUP BY user_id
    HAVING AVG(course_rating) >= 4 AND COUNT(*) >= 5
),
course_sequence AS (
    SELECT a.user_id,
           b.course_name AS first_course,
           LEAD(b.course_name) OVER (PARTITION BY a.user_id ORDER BY completion_date) AS second_course
    FROM top_performer a 
    JOIN course_completions b ON a.user_id = b.user_id
),
consecutive_pairs AS (
    SELECT first_course,
           second_course
    FROM course_sequence
)
SELECT first_course,
       second_course,
       COUNT(*) AS transition_count
FROM consecutive_pairs
GROUP BY first_course, second_course
ORDER BY transition_count DESC, first_course ASC, second_course ASC