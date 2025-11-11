-- 14. Функция для получения местоположений книги с сортировкой по состоянию
CREATE OR REPLACE FUNCTION get_book_locations(
    p_book_id int
)
    RETURNS TABLE(
                     book_title text,
                     inventory_number int,
                     state book_condition,
                     status book_status,
                     location text,
                     condition_order int
                 ) AS $$
BEGIN
    -- Проверка существования книги
    IF NOT EXISTS(SELECT 1 FROM book WHERE book_id = p_book_id) THEN
        RAISE EXCEPTION 'Книга с ID % не найдена', p_book_id;
    END IF;

    RETURN QUERY
        SELECT
            b.title::text,
            bi.inventory_number,
            bi.state,
            bi.status,
            bi.location::text,
            CASE
                WHEN bi.state = 'отличное' THEN 1
                WHEN bi.state = 'хорошее' THEN 2
                WHEN bi.state = 'удовлетворительное' THEN 3
                WHEN bi.state = 'ветхое' THEN 4
                WHEN bi.state = 'утеряна' THEN 5
                ELSE 6
                END AS condition_order
        FROM book_instance bi
                 JOIN book b ON bi.book_id = b.book_id
        WHERE bi.book_id = p_book_id
        ORDER BY
            condition_order,
            bi.inventory_number;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_book_locations(1);