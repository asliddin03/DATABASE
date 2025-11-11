# Работа №1 по базам данных и программированию

## Модель библиотеки

Этот проект представляет собой реализацию реляционной модели библиотеки на PostgreSQL версии 13 и выше.

## Структура базы данных

База данных `t01_library` содержит следующие таблицы:

### 1. Таблица `author`
Хранит информацию об авторах книг:
- `id` (serial, PRIMARY KEY) - внутренний ключ
- `last_name` (varchar) - фамилия автора
- `first_name` (varchar) - имя автора

### 2. Таблица `publishing_house`
Хранит информацию об издательствах:
- `id` (serial, PRIMARY KEY) - внутренний ключ
- `name` (varchar) - название издательства
- `city` (varchar) - город издательства

### 3. Таблица `book`
Хранит информацию о книгах:
- `id` (serial, PRIMARY KEY) - внутренний ключ
- `title` (varchar) - название книги
- `author_id` (integer, FOREIGN KEY) - ссылка на автора
- `publishing_house_id` (integer, FOREIGN KEY) - ссылка на издательство
- `version` (varchar) - версия (издание)
- `publication_year` (integer) - год издания
- `circulation` (integer) - тираж

### 4. Таблица `reader`
Хранит информацию о читателях:
- `ticket_number` (varchar, PRIMARY KEY) - номер читательского билета
- `last_name` (varchar) - фамилия читателя
- `first_name` (varchar) - имя читателя
- `birth_date` (date) - дата рождения
- `gender` (varchar(1)) - пол (M/F)
- `registration_date` (date) - дата регистрации

### 5. Таблица `book_instance`
Хранит информацию о физических экземплярах книг:
- `inventory_number` (varchar, PRIMARY KEY) - инвентарный номер
- `book_id` (integer, FOREIGN KEY) - ссылка на информацию о книге
- `state` (state_enum) - состояние экземпляра
- `status` (status_enum) - статус экземпляра
- `location` (varchar) - местоположение в формате /кабинет/шкаф/полка

### 6. Таблица `issuance`
Хранит информацию о выдаче книг:
- `ticket_number` (varchar, FOREIGN KEY) - номер читательского билета
- `book_instance_id` (varchar, FOREIGN KEY) - инвентарный номер экземпляра
- `issue_datetime` (timestamp) - дата и время выдачи
- `expected_return_date` (date) - ожидаемая дата возврата
- `actual_return_date` (date) - фактическая дата возврата

### 7. Таблица `booking`
Хранит информацию о бронировании книг:
- `id` (serial, PRIMARY KEY) - номер бронирования
- `ticket_number` (varchar, FOREIGN KEY) - номер читательского билета
- `book_id` (integer, FOREIGN KEY) - ссылка на информацию о книге
- `min_state_level` (state_enum) - минимальный требуемый уровень состояния
- `booking_datetime` (timestamp) - дата и время бронирования
