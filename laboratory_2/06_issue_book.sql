-- 6. Функция для выдачи экземпляра книги читателю (упрощенная)
CREATE OR REPLACE FUNCTION issue_book (
    p_card_number int,
    p_inventory_number int,
    p_expected_return_days int DEFAULT 14
)
    RETURNS TABLE(
                     r_card_number int,
                     r_inventory_number int,
                     r_datetime timestamp,
                     r_expected_return_date date
                 ) AS $$
DECLARE
    v_book_status book_status;
BEGIN
    -- Используем общую функцию для проверок
    PERFORM check_reader_and_book_instance_exists(p_card_number, p_inventory_number);

    -- Проверка статуса книги
    SELECT status INTO v_book_status
    FROM book_instance
    WHERE book_instance.inventory_number = p_inventory_number;

    IF v_book_status != 'в наличии' THEN
        RAISE EXCEPTION 'Книга с инвентарным номером % недоступна для выдачи. Текущий статус: %',
            p_inventory_number, v_book_status;
    END IF;

    -- Обновление статуса книги
    UPDATE book_instance
    SET status = 'выдана'
    WHERE inventory_number = p_inventory_number;

    -- Создаем запись о выдаче
    RETURN QUERY
        INSERT INTO issuance(card_number, inventory_number, issue_datetime,
                             expected_return_date, actual_return_date)
            VALUES (p_card_number, p_inventory_number, CURRENT_TIMESTAMP(0),
                    CURRENT_DATE + p_expected_return_days, NULL)
            RETURNING
                issuance.card_number AS r_card_number,
                issuance.inventory_number AS r_inventory_number,
                issuance.issue_datetime AS r_issue_datetime,
                issuance.expected_return_date AS r_expected_return_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM issue_book(1001, 1);