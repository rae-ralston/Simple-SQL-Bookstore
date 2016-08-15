-- CREATE TABLES

DROP TABLE IF EXISTS book;
CREATE TABLE book
(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre
(
  id SERIAL PRIMARY KEY,
  genre VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS book_genre;
CREATE TABLE book_genre
(
  book_id INTEGER NOT NULL,
  genre_id INTEGER NOT NULL
);

DROP TABLE IF EXISTS author;
CREATE TABLE author
(
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS book_author;
CREATE TABLE book_author
(
  book_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL
);


-- INSERT DATA INTO TABLES

INSERT INTO
  book (title)
VALUES 
  ('White Fang'),
  ('Ender''s Game'),
  ('Kushiel''s Dart'),
  ('Dune');

INSERT INTO 
  genre (genre)
VALUES 
  ('Young Adult'),
  ('Sci Fi'),
  ('Romance'),
  ('Fantasy');

INSERT INTO 
  author (first_name, last_name)
VALUES  
  ('Jack', 'London'),
  ('Frank', 'Herbert'),
  ('Jacqueline', 'Carey'),
  ('Orson Scott', 'Card');


-- CONNECT DATA TO EACH OTHER THROUGH JOIN TABLES

INSERT INTO book_genre
SELECT 
  book.id, genre.id
FROM 
  book
CROSS JOIN
  genre
WHERE
  book.title='White Fang'
AND
  genre.title='Young Adult';

INSERT INTO book_genre
SELECT 
  books.i, genre.id
FROM 
  books
CROSS JOIN
  genre
WHERE
  book.title='Ender''s Game'
AND
  genre.title='Sci Fi';

INSERT INTO book_genre
SELECT 
  book.id, genre.id
FROM 
  book
CROSS JOIN
  genre
WHERE
  book.title='Ender''s Game'
AND
  genre.title='Fantasy';

INSERT INTO book_genre
SELECT 
  book.id, genre.id
FROM 
  book
CROSS JOIN
  genre
WHERE
  book.title='Kushiel''s Dart'
AND
  genre.title='Romance';

INSERT INTO book_genre
SELECT 
  book.id, genre.id
FROM 
  book
CROSS JOIN
  genre
WHERE
  book.title='Dune'
AND
  genre.title='Sci Fi';

INSERT INTO book_genre
SELECT 
  book.id, genre.id
FROM 
  book
CROSS JOIN
  genre
WHERE
  book.title='Kushiel''s Dart'
AND
  genre.title='Fantasy';



SELECT 
  book.* 
FROM 
  book
JOIN
  boo_genres
ON 
  book.id=book_genres.book_id
JOIN
  genre
ON 
  book_genre.genre_id=genre.id
WHERE
  genre.title='Young Adult';


SELECT 
  genre.title
FROM 
  genres
JOIN
  book_genre
ON 
  book_genre.genre_id=genre.id
JOIN
  book
ON 
  book.id=book_genre.book_id
WHERE
  book.title='White Fang';




-- give me all the books in the genre "X"
-- give me all the genres for book "X"
-- give me all the books authored by "X"
-- give me the one author book "X"
-- give me all the books where title is like "X"
-- give me all the books with at least one of N genres

