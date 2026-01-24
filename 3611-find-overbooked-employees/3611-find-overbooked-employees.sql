WITH weekly_meetings AS (
    SELECT
        m.employee_id,
        YEARWEEK(m.meeting_date, 1) AS week_id,
        SUM(m.duration_hours) AS weekly_hours
    FROM meetings m
    GROUP BY m.employee_id, YEARWEEK(m.meeting_date, 1)
),
meeting_heavy_weeks AS (
    SELECT
        employee_id
    FROM weekly_meetings
    WHERE weekly_hours > 20
),
heavy_week_count AS (
    SELECT
        employee_id,
        COUNT(*) AS meeting_heavy_weeks
    FROM meeting_heavy_weeks
    GROUP BY employee_id
    HAVING COUNT(*) >= 2
)
SELECT
    e.employee_id,
    e.employee_name,
    e.department,
    h.meeting_heavy_weeks
FROM heavy_week_count h
JOIN employees e
  ON h.employee_id = e.employee_id
ORDER BY h.meeting_heavy_weeks DESC,
         e.employee_name ASC;
