-- 10. Функция выдачи книги с проверкой просрочек
CREATE OR REPLACE FUNCTION issue_book_with_overdue_check (
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
BEGIN
    -- Проверка просрочек через представление
    IF EXISTS(
        SELECT 1 FROM overdue_books_issued
        WHERE reader_full_name IN (
            SELECT last_name || ' ' || first_name FROM reader WHERE card_number = p_card_number
        )
    ) THEN
        RAISE EXCEPTION 'Выдача запрещена! У читателя есть просроченные книги.';
    END IF;

    -- Вызываем функцию выдачи из пункта 6
    RETURN QUERY
        SELECT * FROM issue_book(p_card_number, p_inventory_number,
                                 p_expected_return_days);
END;
$$ LANGUAGE plpgsql;