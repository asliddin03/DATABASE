-- Представление информации о всех выданных книгах
CREATE OR REPLACE VIEW issued_books_view  AS
SELECT
    r.last_name || ' ' || r.first_name AS reader_full_name,
    a.last_name || ' ' || a.first_name AS author_full_name,
    b.title AS book_title,
    bi.state AS book_condition,
    i.issue_datetime,
    r.card_number,
    bi.inventory_number,
    i.expected_return_date
FROM issuance i
    JOIN reader r USING(card_number)
    JOIN book_instance bi USING(inventory_number)
    JOIN book b ON bi.book_id = b.book_id
    JOIN author a ON b.author_id = a.author_id
WHERE i.actual_return_date IS NULL;

-- Проверка представления
SELECT * FROM issued_books_view;
