-- Функция для добавления читателя
CREATE OR REPLACE FUNCTION add_reader(
    p_card_number int,
    p_last_name varchar(50),
    p_first_name varchar(50),
    p_birth_date date,
    p_gender varchar(1),
    p_registration_date date
)
RETURNS TABLE(card_number int) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO reader (card_number, last_name, first_name,
						birth_date, gender, registration_date)
    VALUES (p_card_number, p_last_name, p_first_name,
			p_birth_date, p_gender, p_registration_date)
    RETURNING reader.card_number;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM add_reader(1001, 'Иванов', 'Иван', '1990-05-15', 'М', '2024-01-10');
SELECT * FROM add_reader(1002, 'Петрова', 'Мария', '1985-08-22', 'Ж', '2024-01-11');
SELECT * FROM add_reader(1003, 'Сидоров', 'Алексей', '1995-03-30', 'М', '2024-01-12');

-- Функция для удаления читателя
CREATE OR REPLACE FUNCTION delete_reader(p_card_number int) 
RETURNS void AS $$
BEGIN
    DELETE FROM reader
    WHERE card_number = p_card_number;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM delete_reader(1003);

-- Функция для редактирования информации о читателе
CREATE OR REPLACE FUNCTION update_reader(
    p_card_number int,
    p_last_name varchar DEFAULT NULL,
    p_first_name varchar DEFAULT NULL,
    p_birth_date date DEFAULT NULL,
    p_gender varchar DEFAULT NULL,
    p_registration_date date DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    UPDATE reader
    SET
        last_name = COALESCE(p_last_name, last_name),
        first_name = COALESCE(p_first_name, first_name),
        birth_date = COALESCE(p_birth_date, birth_date),
        gender = COALESCE(p_gender, gender),
        registration_date = COALESCE(p_registration_date, registration_date)
    WHERE card_number = p_card_number;
END;
$$ LANGUAGE plpgsql;

SELECT update_reader(1001, 'Иванов-Петров', NULL, NULL, NULL, NULL);
SELECT update_reader(1001, NULL, 'Иван Сергеевич', NULL, NULL, NULL);
SELECT update_reader(1001, NULL, NULL, '1991-05-15', NULL, NULL);
SELECT update_reader(1001, 'Иванов', 'Иван', '1990-05-15', 'М', '2024-03-01');