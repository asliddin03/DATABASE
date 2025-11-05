-- Функция для выдачи экземпляра книги читателю
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
	v_reader_exists boolean;
	v_book_instance_exists boolean;
BEGIN
	-- Проверка существование читателя
	SELECT EXISTS(
		SELECT 1 FROM reader WHERE card_number = p_card_number
	) INTO v_reader_exists;
	IF NOT v_reader_exists THEN
		RAISE EXCEPTION 'Читатель с номером билета % не найден', p_card_number;
	END IF;
	
	-- Проверка существование экземпляра книги
	SELECT EXISTS(
		SELECT 1 FROM book_instance WHERE inventory_number = p_inventory_number
	) INTO v_book_instance_exists;
	IF NOT v_book_instance_exists THEN
		RAISE EXCEPTION 'Книга с номером билета % не найден', p_inventory_number;
	END IF;

	-- Проверка статус книги
	SELECT status INTO v_book_status
	FROM book_instance
	WHERE book_instance.inventory_number = p_inventory_number;

	IF v_book_status != 'в наличии' THEN
		RAISE EXCEPTION 'Книга с инвентарным номером % недоступна для выдачи. Текущий статус: %', 
                        p_inventory_number, v_book_status;
	END IF;

	-- Обновление статус книги
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

SELECT * FROM issue_book(1001, 2);
SELECT * FROM issue_book(1002, 3, 21);
SELECT * FROM issue_book(1001, 2);