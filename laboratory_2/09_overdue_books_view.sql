-- Представление информации о всех просроченных выданных книгах
CREATE OR REPLACE VIEW overdue_books_issued AS
SELECT
    r.last_name || ' ' || r.first_name AS reader_full_name,
    a.last_name || ' ' || a.first_name AS author_full_name,
    b.title AS book_name,
    i.issue_datetime AS issue_date,
    i.expected_return_date AS expected_return_date,
    CURRENT_DATE - i.expected_return_date AS overdue_days
FROM issuance i
    JOIN reader r USING(card_number)
    JOIN book_instance bi USING(inventory_number)
    JOIN book b ON bi.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
WHERE i.actual_return_date IS NULL
    AND i.expected_return_date < CURRENT_DATE;

-- Проверка представления
SELECT * FROM overdue_books_issued;