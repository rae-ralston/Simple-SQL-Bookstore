-- CREATE TABLES

--psql bookstore < scratch.sql

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
  ('A Scanner Darkly'),
  ('Good Omens');

INSERT INTO 
  genre (genre)
VALUES 
  ('Young Adult'),
  ('Sci Fi'),
  ('Romance'),
  ('Comedy'),
  ('Fantasy');

INSERT INTO 
  author (first_name, last_name)
VALUES  
  ('Jack', 'London'),
  ('Frank', 'Herbert'),
  ('Jacqueline', 'Carey'),
  ('Philip', 'Pullman'),
  ('Orson Scott', 'Card'),
  ('Philip', 'Dick'),
  ('Terry', 'Prachett'),
  ('Neil', 'Gaiman');


-- CONNECT DATA TO EACH OTHER THROUGH JOIN TABLES



--------------------join genres and books

---White fang is a YA book
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='White Fang'
AND genre.genre='Young Adult';

---Good Omens is a Fantasy Book
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='Good Omens'
AND genre.genre='Fantasy';


---Good Omens is a Comedy Book
INSERT INTO book_genre
SELECT book.id, genre.id
FROM book
CROSS JOIN genre
WHERE book.title='Good Omens'
AND genre.genre='Comedy';

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

--Good Omens was written by Terry Prachett
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='Good Omens'
AND author.first_name='Terry'
AND author.last_name='Prachett';

--Good Omens was written by Terry Prachett
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='Good Omens'
AND author.first_name='Neil'
AND author.last_name='Gaiman';


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

--a scanner darkley was written by philip k dick
INSERT INTO book_author
SELECT book.id, author.id
FROM book
CROSS JOIN author
WHERE book.title='A Scanner Darkly'
AND author.first_name='Philip'
AND author.last_name='Dick';



----------------------SEARCHING LIKE CRAZY

--all books with Genra YA
SELECT book.* 
FROM book
JOIN book_genre
ON book.id=book_genre.book_id
JOIN genre
ON book_genre.genre_id=genre.id
WHERE genre.genre='Young Adult';


--all white fang's genre
SELECT genre.genre
FROM genre
JOIN book_genre
ON book_genre.genre_id=genre.id
JOIN book
ON book.id=book_genre.book_id
WHERE book.title='White Fang';

-- give me all the genres for book "X"
SELECT DISTINCT(genre.*)
FROM genre
JOIN book_genre
ON genre.id=book_genre.genre_id
JOIN book
ON book_genre.book_id=book.id
WHERE book.title='Kushiel''s Dart';

-- get book.title by author_id
SELECT DISTINCT(book.*)
FROM book 
JOIN book_author
ON book.id=book_author.book_id
JOIN author
ON book_author.author_id=author.id
WHERE author.first_name='Philip'
AND author.last_name='Pullman';

-- get author name by book title
SELECT DISTINCT(author.*)
FROM author 
JOIN book_author
ON author.id=book_author.author_id
JOIN book
ON book_author.book_id=book.id
WHERE book.title='Good Omens';

-- get book.title by pattern: First letter of last name (p)
-- https://www.postgresql.org/docs/8.3/static/functions-matching.html
SELECT DISTINCT(book.*)
FROM book 
JOIN book_author
ON book.id=book_author.book_id
JOIN author
ON book_author.author_id=author.id
WHERE author.last_name LIKE 'P%';

-- get book.title by pattern: Part of a last name? Pull for pullman
SELECT DISTINCT(book.*)
FROM book 
JOIN book_author
ON book.id=book_author.book_id
JOIN author
ON book_author.author_id=author.id
WHERE author.last_name SIMILAR TO 'Pull_';

-- get book.title by pattern: Part of a last name? Pull for pullman
SELECT *
FROM book 

-- give me all the books with at least one of N genres

