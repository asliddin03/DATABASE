-- Функция для добавления издательства
CREATE OR REPLACE FUNCTION add_publishing_house(p_name varchar(100), p_city varchar(100))
RETURNS TABLE(publishing_house_id int) AS $$
BEGIN
	RETURN QUERY
	INSERT INTO publishing_house(name, city)
	VALUES (p_name, p_city)
	RETURNING publishing_house.publishing_house_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM add_publishing_house('Эксмо', 'Москва');
SELECT * FROM add_publishing_house('Питер', 'Санкт-Петербург');
SELECT * FROM add_publishing_house('Литрес', 'Москва');

-- Функция для удаления издательства
CREATE OR REPLACE FUNCTION delete_publishing_house(p_publishing_house_id int)
RETURNS void AS $$
BEGIN
	DELETE FROM publishing_house
	WHERE publishing_house_id = p_publishing_house_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM delete_publishing_house(3);

-- Функция для редактирования издательства
CREATE OR REPLACE FUNCTION update_publishing_house(
	p_publishing_house_id int,
	p_name varchar,
	p_city varchar
)
RETURNS void AS $$
BEGIN
	UPDATE publishing_house
	SET
		name = COALESCE(p_name, name),
		city = COALESCE(p_city, city)
	WHERE p_publishing_house_id = publishing_house_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_publishing_house(1, 'Эксмо-Пресс', NULL);
SELECT update_publishing_house(1, NULL, 'Москва'); 
SELECT update_publishing_house(1, 'Эксмо', 'Москва');
SELECT update_publishing_house(1, NULL, NULL);