-- 11. Функция бронирования книги для читателя (упрощенная)
CREATE OR REPLACE FUNCTION create_booking (
    p_card_number int,
    p_book_id int
)
    RETURNS TABLE(
                     booking_id int,
                     reader_name text,
                     book_title text,
                     booking_expiry_date date
                 ) AS $$
DECLARE
    v_available_copy_exists boolean;
    v_reader_name text;
    v_book_title text;
BEGIN
    PERFORM check_reader_and_book_exists(p_card_number, p_book_id);

    -- Проверка наличия доступных экземпляров
    SELECT EXISTS(
        SELECT 1
        FROM book_instance bi
        WHERE bi.book_id = p_book_id
          AND bi.status = 'в наличии'
    ) INTO v_available_copy_exists;

    IF NOT v_available_copy_exists THEN
        RAISE EXCEPTION 'Нет доступных экземпляров книги';
    END IF;

    -- Получаем данные для возврата
    SELECT last_name || ' ' || first_name INTO v_reader_name
    FROM reader WHERE card_number = p_card_number;

    SELECT title INTO v_book_title
    FROM book WHERE book_id = p_book_id;

    -- Создаем запись о бронировании
    RETURN QUERY
        INSERT INTO booking(card_number, book_id, min_condition_level, booking_datetime)
            VALUES (p_card_number, p_book_id, 'удовлетворительное', CURRENT_TIMESTAMP(0))
            RETURNING
                booking.booking_id,
                v_reader_name::text,
                v_book_title::text,
                (CURRENT_DATE + 2)::date;
END;
$$ LANGUAGE plpgsql;

-- Проверка функции выдачи
SELECT * FROM issue_book(1001, 1);

-- Проверка функции бронирования
SELECT * FROM create_booking(1001, 1);

