-- 15. Представление с информацией о доступных экземплярах книг
CREATE OR REPLACE VIEW available_books_summary_view AS
SELECT
    b.book_id,
    b.title AS book_title,
    a.last_name || ' ' || a.first_name AS author_name,
    ph.name AS publishing_house,
    bi.state AS book_condition,
    COUNT(bi.inventory_number) AS available_copies_count,
    STRING_AGG(bi.location, '; ') AS locations
FROM book_instance bi
         JOIN book b ON bi.book_id = b.book_id
         JOIN author a ON b.author_id = a.author_id
         JOIN publishing_house ph ON b.publishing_house_id = ph.publishing_house_id
WHERE bi.status = 'в наличии'
  AND bi.state != 'утеряна'
GROUP BY
    b.book_id,
    b.title,
    a.last_name,
    a.first_name,
    ph.name,
    bi.state
ORDER BY
    a.last_name,
    a.first_name,
    b.title,
    CASE bi.state
    WHEN 'отличное' THEN 1
    WHEN 'хорошее' THEN 2
    WHEN 'удовлетворительное' THEN 3
    WHEN 'ветхое' THEN 4
    ELSE 5
END;

SELECT * FROM available_books_summary_view;