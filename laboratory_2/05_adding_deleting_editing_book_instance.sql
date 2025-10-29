-- Функция для добавления экземпляра книги
CREATE OR REPLACE FUNCTION add_book_instance(
    p_book_id int,
    p_state book_condition,
    p_status book_status,
    p_location varchar(100)
)
RETURNS TABLE(inventory_number int) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO book_instance (book_id, state, status, location)
    VALUES (p_book_id, p_state, p_status, p_location)
    RETURNING book_instance.inventory_number;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM add_book_instance(1, 'отличное', 'в наличии', '/101/шкаф1/полка2');
SELECT * FROM add_book_instance(1, 'хорошее', 'выдана', '/101/шкаф1/полка3');
SELECT * FROM add_book_instance(2, 'удовлетворительное', 'в наличии', '/102/шкаф2/полка1');
SELECT * FROM add_book_instance(3, 'ветхое', 'забронирована', '/103/шкаф3/полка1');

-- Функция для удаления экземпляра книги
CREATE OR REPLACE FUNCTION delete_book_instance(p_inventory_number int) 
RETURNS void AS $$
BEGIN
    DELETE FROM book_instance
    WHERE inventory_number = p_inventory_number;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM delete_book_instance(5);

-- Функция для редактирования информации об экземпляре книги
CREATE OR REPLACE FUNCTION update_book_instance(
    p_inventory_number int,
    p_book_id int DEFAULT NULL,
    p_state book_condition DEFAULT NULL,
    p_status book_status DEFAULT NULL,
    p_location varchar DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    UPDATE book_instance
    SET
        book_id = COALESCE(p_book_id, book_id),
        state = COALESCE(p_state, state),
        status = COALESCE(p_status, status),
        location = COALESCE(p_location, location)
    WHERE inventory_number = p_inventory_number;
END;
$$ LANGUAGE plpgsql;

SELECT update_book_instance(1, NULL, 'хорошее', NULL, NULL);
SELECT update_book_instance(1, 1, 'отличное', 'в наличии', '/101/шкаф1/полка2');