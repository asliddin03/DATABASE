-- Функция отмены бронирования книги для читателя
CREATE OR REPLACE FUNCTION cancel_booking(
    p_card_number int,
    p_book_id int
)
RETURNS TABLE(
    success_massage text
) AS $$
DECLARE
    v_cancelled_count int;
BEGIN
    -- Удаляем все активные бронирования этого читателя для указанной книги
    WITH deleted AS (
        DELETE FROM booking
        WHERE card_number = p_card_number
            AND book_id = p_book_id
            AND booking_datetime IS NOT NULL
        RETURNING *
    )
    SELECT count(*) INTO v_cancelled_count FROM deleted;

    IF v_cancelled_count = 0 THEN
        RAISE EXCEPTION 'Активных бронирований не найдено для читателя % и книг %',
            p_card_number, p_book_id;
    END IF;

    RETURN QUERY
    SELECT
        'Бронирование отменено'::text;
END;
$$ LANGUAGE plpgsql;

-- Проверка функции
SELECT * FROM cancel_booking(1001, 1);