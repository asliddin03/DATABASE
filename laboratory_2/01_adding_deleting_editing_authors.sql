-- Функция для добавления автора
CREATE OR REPLACE FUNCTION add_author(p_last_name varchar(50), p_first_name varchar(50))
	RETURNS TABLE(author_id int) AS $$
BEGIN
	RETURN QUERY
	INSERT INTO author (last_name, first_name)
	VALUES (p_last_name, p_first_name)
	RETURNING author.author_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM add_author('Толстой', 'Лев');
SELECT * FROM add_author('Достоевский', 'Фёдор');
SELECT * FROM add_author('Пушкин', 'Александр');
SELECT * FROM add_author('Гоголь', 'Николай');

-- Функция для удаления автора
CREATE OR REPLACE FUNCTION delete_author(p_author_id int) RETURNS void AS $$
BEGIN
	DELETE FROM author
	WHERE author_id = p_author_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM delete_author(3);

-- Функция для редактирования автора
CREATE OR REPLACE FUNCTION update_author(
    p_author_id int, 
    p_last_name varchar DEFAULT NULL, 
    p_first_name varchar DEFAULT NULL
)
RETURNS void AS $$
BEGIN
    UPDATE author
    SET
        last_name = COALESCE(p_last_name, last_name),
        first_name = COALESCE(p_first_name, first_name)
    WHERE author_id = p_author_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_author(1, 'НоваяФамилия', NULL); 
SELECT update_author(1, NULL, 'НовоеИмя');
SELECT update_author(1, 'НоваяФамилия', 'НовоеИмя');
SELECT update_author(1, NULL, NULL);
SELECT update_author(1, 'Толстой', 'Лев Николаевич');
