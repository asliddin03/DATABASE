-- Вспомогательная функция для проверки существования читателя и экземпляра книги
CREATE OR REPLACE FUNCTION check_reader_and_book_exists(
    p_card_number int,
    p_inventory_number int
) RETURNS void AS $$
DECLARE
v_reader_exists boolean;
    v_book_instance_exists boolean;
BEGIN
    -- Проверка существования читателя
SELECT EXISTS(SELECT 1 FROM reader WHERE card_number = p_card_number) INTO v_reader_exists;
IF NOT v_reader_exists THEN
        RAISE EXCEPTION 'Читатель с номером билета % не найден', p_card_number;
END IF;

    -- Проверка существования экземпляра книги
SELECT EXISTS(SELECT 1 FROM book_instance WHERE inventory_number = p_inventory_number) INTO v_book_instance_exists;
IF NOT v_book_instance_exists THEN
        RAISE EXCEPTION 'Книга с инвентарным номером % не найдена', p_inventory_number;
END IF;
END;
$$ LANGUAGE plpgsql;