CREATE TABLE author
(
	author_id SERIAL PRIMARY KEY,
	last_name VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL
);

CREATE TABLE publishing_house
(
	publishing_house_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	city VARCHAR(100) NOT NULL
);

CREATE TABLE book
(
	book_id SERIAL PRIMARY KEY,
	title TEXT NOT NULL,
	author_id INTEGER NOT NULL REFERENCES public.author(author_id),
	publishing_house_id INTEGER NOT NULL REFERENCES public.publishing_house(publishing_house_id),
	version VARCHAR(50),
	publishing_year INTEGER NOT NULL,
	circulation INTEGER
);

CREATE TABLE reader
(
	card_number INTEGER PRIMARY KEY,
	last_name VARCHAR(50) NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	birth_date DATE NOT NULL,
	gender VARCHAR(1) NOT NULL,
	registration_date DATE NOT NULL
);

CREATE TYPE book_condition AS ENUM ('отличное', 'хорошее', 'удовлетворительное', 'ветхое', 'утеряна');
CREATE TYPE book_status AS ENUM ('в наличии', 'выдана', 'забронирована');

CREATE TABLE book_instance
(
	inventory_number SERIAL PRIMARY KEY,
	book_id INTEGER NOT NULL REFERENCES public.book(book_id),
	state book_condition NOT NULL,
	status book_status NOT NULL,
	location VARCHAR(100) NOT NULL
);

CREATE TABLE issuance
(
    issue_id SERIAL PRIMARY KEY,
    card_number INTEGER NOT NULL REFERENCES reader(card_number),
    inventory_number INTEGER NOT NULL REFERENCES book_instance(inventory_number),
	issue_datetime TIMESTAMP(0) NOT NULL,
	expected_return_date DATE NOT NULL,
    actual_return_date DATE
);

CREATE TABLE booking
(
	 booking_id SERIAL PRIMARY KEY,
	 card_number INTEGER REFERENCES public.reader(card_number),
	 book_id INTEGER NOT NULL REFERENCES public.book(book_id),
	 min_condition_level book_condition NOT NULL,
	 booking_datetime TIMESTAMP(0) NOT NULL
);
