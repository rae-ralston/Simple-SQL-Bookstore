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
  ('The Golden Compass'),
  ('The Subtle Knife'),
  ('Dune'),
  ('A Scanner Darkly');

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
  ('Philip', 'Pullman'),
  ('Orson Scott', 'Card'),
  ('Philip', 'Dick');


-- CONNECT DATA TO EACH OTHER THROUGH JOIN TABLES



--------------------join genres and books

---White fang is a YA book
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='White Fang'
AND genre.genre='Young Adult';

---golden compass is a YA book
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='The Golden Compass'
AND genre.genre='Young Adult';

--enders game is scifi
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='Ender''s Game'
AND genre.genre='Sci Fi';

--kushie's dart is a romance novel
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='Kushiel''s Dart'
AND genre.genre='Romance';

-- dune is a scifi novel
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='Dune'
AND genre.genre='Sci Fi';

--kushie's dart is a fantasy novel
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='Kushiel''s Dart'
AND genre.genre='Fantasy';


INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='The Subtle Knife'
AND genre.genre='Young Adult';

INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='A Scanner Darkly'
AND genre.genre='Sci Fi';

INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='A Scanner Darkly'
AND genre.genre='Fantasy';



--------------------join books and authors

--kushie's dart written jacqueline carey
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='Kushiel''s Dart'
AND author.first_name='Jacqueline'
AND author.last_name='Carey';


--white fang was written by jack london
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='White Fang'
AND author.first_name='Jack'
AND author.last_name='London';


--Ender's Game was written by orson scott card
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='Ender''s Game'
AND author.first_name='Orson Scott'
AND author.last_name='Card';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='The Golden Compass'
AND author.first_name='Philip'
AND author.last_name='Pullman';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='The Subtle Knife'
AND author.first_name='Philip'
AND author.last_name='Pullman';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='Dune'
AND author.first_name='Frank'
AND author.last_name='Herbert';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='A Scanner Darkly'
AND author.first_name='Philip'
AND author.last_name='Dick';



----------------------SEARCHING LIKE CRAZY

--select all books, from books, join into book_genres
SELECT book.* 
FROM book
JOIN book_genre
ON book.id=book_genre.book_id
JOIN genre
ON book_genre.genre_id=genre.id
WHERE genre.genre='Young Adult';


SELECT genre.title
FROM genres
JOIN book_genre
ON book_genre.genre_id=genre.id
JOIN book
ON book.id=book_genre.book_id
WHERE book.title='White Fang';


---------------------------------

--- get all authors
SELECT *
FROM author

--- get all books
SELECT *
FROM book

-- give me all the genres for book "X"
SELECT DISTINCT(genre.*)
FROM genre
JOIN book_genre
ON genre.id=book_genre.genre_id
JOIN book
ON book_genre.book_id=book.id
WHERE book.title='Kushiel''s Dart';

-- give me all the books in the genre "X"
SELECT DISTINCT(book.*)
FROM book
INNER JOIN book_genre
ON book.id=book_genre.book_id
INNER JOIN genre
ON book_genre.genre_id=genre.id
WHERE genre.genre='Young Adult';

-- give me all the books authored by "X"
SELECT author.*
FROM author 
JOIN book_author
ON author.id=book_author.author_id
JOIN book
ON book_author.book_id=book.id
WHERE author.first_name='Philip'
AND author.last_name='Pullman';

-- give me the one author book "X"
-- give me all the books where title is like "X"
-- give me all the books with at least one of N genres

