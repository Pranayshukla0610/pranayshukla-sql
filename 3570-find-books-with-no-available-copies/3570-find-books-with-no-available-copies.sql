# Write your MySQL query statement below
WITH currently_borrowed AS (
    SELECT book_id,
           COUNT(*) AS current_borrowers
    FROM borrowing_records
    WHERE return_date IS NULL
    GROUP BY book_id
)
SELECT lb.book_id,
       lb.title,
       lb.author,
       lb.genre,
       lb.publication_year,
       cb.current_borrowers
FROM library_books lb
JOIN currently_borrowed cb
  ON lb.book_id = cb.book_id
WHERE cb.current_borrowers = lb.total_copies
ORDER BY cb.current_borrowers DESC,
         lb.title ASC;
