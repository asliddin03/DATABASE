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

-- Функция для удаления автора
CREATE OR REPLACE FUNCTION delete_author(p_author_id int)
	RETURNS TABLE(deleted_author_id int) AS $$
BEGIN
	RETURN QUERY
	DELETE FROM author
	WHERE author_id = p_author_id
	RETURNING author.author_id;
END;
$$ LANGUAGE plpgsql

SELECT * FROM delete_author(3);

-- Функция для редактирования автора
CREATE OR REPLACE FUNCTION update_author(
	p_author_id int, 
	p_last_name varchar(50), 
	p_first_name varchar(50)
)
RETURNS TABLE(updated_author_id int) AS $$
BEGIN
	RETURN QUERY
	UPDATE author
	SET
		last_name = p_last_name,
        first_name = p_first_name
	WHERE author_id = p_author_id
	RETURNING author.author_id;
END;
$$ LANGUAGE plpgsql

SELECT * FROM update_author(1, 'Толстой', 'Лев Николаевич');