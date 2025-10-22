-- 1. Операции для таблицы author

INSERT INTO author (last_name, first_name) VALUES
('Толстой', 'Лев'),
('Достоевский', 'Федор'),
('Чехов', 'Антон'),
('Булгаков', 'Михаил')
RETURNING author_id

UPDATE author 
SET last_name = CASE 
    WHEN author_id = 1 THEN 'Пушкин'
    WHEN author_id = 2 THEN 'Гоголь'
    ELSE last_name
END,
first_name = CASE 
    WHEN author_id = 1 THEN 'Александр'
    WHEN author_id = 2 THEN 'Николай'
    ELSE first_name
END
WHERE author_id IN (1, 2);


-- 2. Операции для таблицы publishing_house

INSERT INTO publishing_house (name, city) VALUES 
('Эксмо', 'Москва'),
('АСТ', 'Москва'),
('Питер', 'Санкт-Петербург'),
('Дрофа', 'Москва')
RETURNING publishing_house_id;

UPDATE publishing_house 
SET city = CASE 
    WHEN publishing_house_id = 3 THEN 'Москва'
    WHEN publishing_house_id = 4 THEN 'Санкт-Петербург'
    ELSE city
END
WHERE publishing_house_id IN (3, 4);

DELETE FROM publishing_house 
WHERE publishing_house_id IN (2, 4);

-- 3. Операции для таблицы book
INSERT INTO book (title, author_id, publishing_house_id, version, publishing_year, circulation) VALUES 
('Война и мир', 1, 1, 'Первое издание', 1869, 5000),
('Преступление и наказание', 2, 3, 'Классическое издание', 1866, 3000),
('Мастер и Маргарита', 4, 1, 'Юбилейное издание', 1967, 10000),
('Вишневый сад', 3, 3, 'Сборник пьес', 1904, 2000)
RETURNING book_id;

UPDATE book 
SET version = 'Обновленное издание',
    circulation = circulation + 1000
WHERE book_id IN (1, 3);

DELETE FROM book 
WHERE book_id IN (2, 4);

-- 4. Операции для таблицы reader (несколько экземпляров)
INSERT INTO reader (card_number, last_name, first_name, birth_date, gender, registration_date)
VALUES 
(1001, 'Иванов', 'Петр', '1990-05-15', 'М', CURRENT_DATE),
(1002, 'Петрова', 'Мария', '1985-08-22', 'Ж', CURRENT_DATE),
(1003, 'Сидоров', 'Алексей', '1995-12-10', 'М', CURRENT_DATE),
(1004, 'Козлова', 'Ольга', '1988-03-30', 'Ж', CURRENT_DATE)
RETURNING card_number;

UPDATE reader 
SET last_name = CASE 
    WHEN card_number = 1001 THEN 'Иванов-Петров'
    WHEN card_number = 1003 THEN 'Сидоров-Иванов'
    ELSE last_name
END
WHERE card_number IN (1001, 1003);

DELETE FROM reader 
WHERE card_number IN (1002, 1004);

-- 5. Операции для таблицы book_instance (несколько экземпляров)
INSERT INTO book_instance (book_id, state, status, location) VALUES 
(1, 'отличное', 'в наличии', '/101/шкафА/полка3'),
(1, 'хорошее', 'в наличии', '/101/шкафА/полка4'),
(3, 'удовлетворительное', 'выдана', '/102/шкафБ/полка1'),
(3, 'ветхое', 'в наличии', '/102/шкафБ/полка2')
RETURNING inventory_number;

UPDATE book_instance 
SET status = CASE 
    WHEN inventory_number IN (1, 2) THEN 'забронирована'
    WHEN inventory_number = 3 THEN 'в наличии'
    ELSE status
END,
state = CASE 
    WHEN inventory_number = 4 THEN 'удовлетворительное'
    ELSE state
END
WHERE inventory_number IN (1, 2, 3, 4);

DELETE FROM book_instance 
WHERE inventory_number IN (2, 4);