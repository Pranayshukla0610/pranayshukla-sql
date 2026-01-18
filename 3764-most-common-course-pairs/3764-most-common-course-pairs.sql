# Write your MySQL query statement below
WITH filter_data AS (
    SELECT user_id
    FROM course_completions
    GROUP BY user_id
    HAVING AVG(course_rating) >= 4 AND COUNT(*) >= 5
),
sequence_courses AS (
    SELECT b.course_name AS first_course,
           a.user_id,
           LEAD(b.course_name) OVER (PARTITION BY user_id ORDER BY completion_date) AS second_course
    FROM filter_data a 
    JOIN course_completions b ON a.user_id = b.user_id
),
pair_courses AS (
    SELECT first_course,
           second_course
    FROM sequence_courses
    WHERE second_course IS NOT NULL
)
SELECT first_course,
       second_course,
       COUNT(*) AS transition_count
FROM pair_courses
GROUP BY first_course, second_course
ORDER BY transition_count DESC, first_course ASC, second_course ASC