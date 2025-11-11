-- Представление с информацией о книгах, не возвращенных более года
CREATE OR REPLACE VIEW long_overdue_books_view AS
SELECT
    r.card_number,
    r.last_name || ' ' || r.first_name AS reader_full_name,
    a.last_name || ' ' || a.first_name AS author_name,
    b.title AS book_title,
    bi.inventory_number,
    bi.state AS book_condition,
    i.issue_datetime AS issue_date,
    i.expected_return_date AS expected_return_date,
    CURRENT_DATE - i.issue_datetime::date AS days_since_issue,
    (CURRENT_DATE - i.expected_return_date) AS overdue_days
FROM issuance i
         INNER JOIN reader r ON i.card_number = r.card_number
         INNER JOIN book_instance bi ON i.inventory_number = bi.inventory_number
         INNER JOIN book b ON bi.book_id = b.book_id
         INNER JOIN author a ON b.author_id = a.author_id
WHERE i.actual_return_date IS NULL  -- Книга не возвращена
  AND i.issue_datetime < (CURRENT_DATE - INTERVAL '1 year')
ORDER BY
    i.issue_datetime,
    overdue_days DESC;

SELECT * FROM long_overdue_books_view;