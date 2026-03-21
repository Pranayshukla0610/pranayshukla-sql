# Write your MySQL query statement below
WITH top_performers AS (
    SELECT user_id
    FROM course_completions
    GROUP BY user_id
    HAVING COUNT(*) >= 5
       AND AVG(course_rating) >= 4
),

ordered_courses AS (
    SELECT 
        cc.user_id,
        cc.course_name,
        cc.completion_date,
        LEAD(cc.course_name) OVER (
            PARTITION BY cc.user_id 
            ORDER BY cc.completion_date
        ) AS next_course
    FROM course_completions cc
    JOIN top_performers tp 
        ON cc.user_id = tp.user_id
)

SELECT 
    course_name AS first_course,
    next_course AS second_course,
    COUNT(*) AS transition_count
FROM ordered_courses
WHERE next_course IS NOT NULL
GROUP BY course_name, next_course
ORDER BY transition_count DESC, first_course, second_course;