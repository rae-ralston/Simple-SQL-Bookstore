-- CREATE TABLES

--psql bookstore < scratch.sql

DROP TABLE IF EXISTS books;
CREATE TABLE books
(
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS genres;
CREATE TABLE genres
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

DROP TABLE IF EXISTS authors;
CREATE TABLE authors
(
  id SERIAL PRIMARY KEY,
  author VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS book_author;
CREATE TABLE book_author
(
  book_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL
);


-- INSERT DATA INTO TABLES

INSERT INTO
  books (title)
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
  genres (genre)
VALUES 
  ('Young Adult'),
  ('Sci Fi'),
  ('Romance'),
  ('Comedy'),
  ('Fantasy');

INSERT INTO 
  authors (author)
VALUES  
  ('Jack London'),
  ('Frank Herbert'),
  ('Jacqueline Carey'),
  ('Philip Pullman'),
  ('Orson Scott Card'),
  ('Philip Dick'),
  ('Terry Prachett'),
  ('Neil Gaiman');


-- CONNECT DATA TO EACH OTHER THROUGH JOIN TABLES



--------------------join genres and books

---White fang is a YA book
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='White Fang'
AND genres.genre='Young Adult';

---Good Omens is a Fantasy Book
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Good Omens'
AND genres.genre='Fantasy';


---Good Omens is a Comedy Book
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Good Omens'
AND genres.genre='Comedy';

---golden compass is a YA book
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='The Golden Compass'
AND genres.genre='Young Adult';

--enders game is scifi
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Ender''s Game'
AND genres.genre='Sci Fi';

--kushie's dart is a romance novel
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Kushiel''s Dart'
AND genres.genre='Romance';

-- dune is a scifi novel
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Dune'
AND genres.genre='Sci Fi';

--kushie's dart is a fantasy novel
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Kushiel''s Dart'
AND genres.genre='Fantasy';


INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='The Subtle Knife'
AND genres.genre='Young Adult';

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='A Scanner Darkly'
AND genres.genre='Sci Fi';

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='A Scanner Darkly'
AND genres.genre='Fantasy';



--------------------join books and authors

--kushie's dart written jacqueline carey
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Kushiel''s Dart'
AND authors.author='Jacqueline Carey';

--Good Omens was written by Terry Prachett
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Good Omens'
AND authors.author='Terry Carey';

--Good Omens was written by Terry Prachett
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Good Omens'
AND authors.author='Neil Gaiman';


--white fang was written by jack london
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='White Fang'
AND authors.author='Jack London';


--Ender's Game was written by orson scott card
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Ender''s Game'
AND authors.author='Orson Scott Card';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='The Golden Compass'
AND authors.author='Philip Pullman';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='The Subtle Knife'
AND authors.author='Philip Pullman';

--the golden compass was written by philip pullman
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Dune'
AND authors.author='Frank Herbert';

--a scanner darkley was written by philip k dick
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='A Scanner Darkly'
AND authors.author='Philip K Dick';



----------------------SEARCHING LIKE CRAZY

--all books with Genra YA
SELECT books.* 
FROM books
JOIN book_genre
ON books.id=book_genre.book_id
JOIN genres
ON book_genre.genre_id=genres.id
WHERE genres.genre='Young Adult';


--all white fang's genre
SELECT genres.genre
FROM genres
JOIN book_genre
ON book_genre.genre_id=genres.id
JOIN books
ON books.id=book_genre.book_id
WHERE books.title='White Fang';

-- give me all the genres for book "X"
SELECT DISTINCT(genres.*)
FROM genres
JOIN book_genre
ON genres.id=book_genre.genre_id
JOIN books
ON book_genre.book_id=books.id
WHERE books.title='Kushiel''s Dart';

-- get book.title by author_id
SELECT DISTINCT(books.*)
FROM books
JOIN book_author
ON books.id=book_author.book_id
JOIN authors
ON book_author.author_id=authors.id
WHERE authors.author='Philip Pullman';

-- get author name by book title
SELECT DISTINCT(authors.*)
FROM authors
JOIN book_author
ON authors.id=book_author.author_id
JOIN books
ON book_author.book_id=books.id
WHERE books.title='Good Omens';

--to get all authors for books 3,4,5
SELECT authors.*
FROM authors
JOIN book_author
ON authors.id=book_author.author_id
WHERE book_author.book_id IN (3,4,5);

-- get book.title by pattern: First letter of last name (p)
-- https://www.postgresql.org/docs/8.3/static/functions-matching.html
SELECT DISTINCT(books.*)
FROM books 
JOIN book_author
ON books.id=book_author.book_id
JOIN authors
ON book_author.author_id=authors.id
WHERE authors.author LIKE 'P%';

-- get book.title by pattern: Part of a last name? Pull for pullman
SELECT DISTINCT(books.*)
FROM books
JOIN book_author
ON books.id=book_author.book_id
JOIN authors
ON book_author.author_id=authors.id
WHERE authors.author LIKE 'Nei%';


-- give me all the books with at least one of N genres

