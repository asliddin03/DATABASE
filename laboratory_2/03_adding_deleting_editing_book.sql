-- Функция для добавления книги
CREATE OR REPLACE FUNCTION add_book(
	p_title text,
	p_author_id int,
	p_publishing_house_id int,
	p_version varchar(50),
	p_publishing_year int,
	p_circulation int
)
RETURNS TABLE(book_id int) AS $$
BEGIN
	RETURN QUERY
	INSERT INTO book(title, author_id, publishing_house_id,
				version, publishing_year, circulation)
    VALUES (p_title, p_author_id, p_publishing_house_id,
			p_version, p_publishing_year, p_circulation)
	RETURNING book.book_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM add_book('Война и мир', 1, 1, 'Первое издание', 1869, 5000);
SELECT * FROM add_book('Преступление и наказание', 2, 2, NULL, 1866, 3000);
SELECT * FROM add_book('Мастер и Маргарита', 2, 1, 'Юбилейное издание', 1967, 10000);
SELECT * FROM add_book('random', 2, 2, 'random', 2025, 10000);

-- Функция для удаления книги
CREATE OR REPLACE FUNCTION delete_book(p_book_id int)
RETURNS void AS $$
BEGIN
	DELETE FROM BOOK
	WHERE book_id = p_book_id;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM delete_book(4);

-- Функция для редактирования информации о книге
CREATE OR REPLACE FUNCTION update_book(
    p_book_id int,
    p_title text DEFAULT NULL,
    p_author_id int DEFAULT NULL,
    p_publishing_house_id int DEFAULT NULL,
    p_version varchar DEFAULT NULL,
    p_publishing_year int DEFAULT NULL,
    p_circulation int DEFAULT NULL
)
RETURNS void AS $$
BEGIN
	UPDATE book
	SET
		title = COALESCE(p_title, title),
		author_id = COALESCE(p_author_id, author_id),
        publishing_house_id = COALESCE(p_publishing_house_id, publishing_house_id),
        version = COALESCE(p_version, version),
        publishing_year = COALESCE(p_publishing_year, publishing_year),
        circulation = COALESCE(p_circulation, circulation)
    WHERE book_id = p_book_id;
END;
$$ LANGUAGE plpgsql;

SELECT update_book(1, 'Война и мир. Том 1-4', NULL, NULL, NULL, NULL, NULL);
SELECT update_book(1, NULL, NULL, NULL, 'Полное собрание', NULL, NULL);
SELECT update_book(1, NULL, NULL, NULL, NULL, NULL, 6000);
SELECT update_book(1, 'Война и мир', 1, 1, 'Исправленное издание', 1870, 5500);