-- Функция для проверки существования читателя и книги
CREATE OR REPLACE FUNCTION check_reader_and_book_exists(
    p_card_number int,
    p_book_id int
) RETURNS void AS $$
DECLARE
v_reader_exists boolean;
    v_book_exists boolean;
BEGIN
    -- Проверка существования читателя
SELECT EXISTS(SELECT 1 FROM reader WHERE card_number = p_card_number) INTO v_reader_exists;
IF NOT v_reader_exists THEN
        RAISE EXCEPTION 'Читатель с номером билета % не найден', p_card_number;
END IF;

    -- Проверка существования книги
SELECT EXISTS(SELECT 1 FROM book WHERE book_id = p_book_id) INTO v_book_exists;
IF NOT v_book_exists THEN
        RAISE EXCEPTION 'Книга с ID % не найдена', p_book_id;
END IF;
END;
$$ LANGUAGE plpgsql;