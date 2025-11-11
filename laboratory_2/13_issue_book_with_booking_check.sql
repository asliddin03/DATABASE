-- Функция выдачи с проверкой бронирования другими читателями
CREATE OR REPLACE FUNCTION issue_book_with_booking_check (
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
    v_book_id int;
    v_is_booked_by_other boolean;
BEGIN
    -- Получаем book_id
    SELECT book_id INTO v_book_id
    FROM book_instance
    WHERE inventory_number = p_inventory_number;

    -- Проверка: не забронирована ли книга другим читателем
    SELECT EXISTS(
        SELECT 1
        FROM booking
        WHERE book_id = v_book_id
            AND card_number != p_card_number
    ) INTO v_is_booked_by_other;

    IF v_is_booked_by_other THEN
        RAISE EXCEPTION 'Выдача запрещена: книга забронирована другим читателем';
    END IF;
    -- Вызываем функцию выдачи
    RETURN QUERY
    SELECT * FROM issue_book(p_card_number, p_inventory_number,
                             p_expected_return_days);
END;
$$ LANGUAGE plpgsql;

SELECT * FROM issue_book_with_booking_check(1001, 3);