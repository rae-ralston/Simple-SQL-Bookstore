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
  ('Good Omens'),
  ('Neuromancer'), 
  ('1984'),
  ('Hyperion'),
  ('Fahrenheit 451'),
  ('The Left Hand of Darkness');

INSERT INTO 
  genres (genre)
VALUES 
  ('Young Adult'),
  ('Sci Fi'),
  ('Romance'),
  ('Comedy'),
  ('Fantasy'),
  ('Space'),
  ('Aliens'),
  ('Strong Female Lead'),
  ('Dystopia'),
  ('Female Author'),
  ('Classic');

INSERT INTO 
  authors (author)
VALUES  
  ('Jack London'),
  ('Frank Herbert'),
  ('Jacqueline Carey'),
  ('Philip Pullman'),
  ('Orson Scott Card'),
  ('Philip K Dick'),
  ('Terry Prachett'),
  ('Neil Gaiman'), 
  ('William Gibson'),
  ('George Orwell'),
  ('Dan Simmons'),
  ('Ray Bradbury'),
  ('Ursula K Le Guin');


-- CONNECT DATA TO EACH OTHER THROUGH JOIN TABLES



--------------------join genres and books
--  ('1984'), is classic, 
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='1984'
AND genres.genre='Classic';

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='1984'
AND genres.genre='Classic';

--('Hyperion'),
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Hyperion'
AND genres.genre='Aliens';

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Hyperion'
AND genres.genre='Sci Fi';

--('Fahrenheit 451'),
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Fahrenheit 451'
AND genres.genre='Dystopia';

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Fahrenheit 451'
AND genres.genre='Young Adult';

--('The Left Hand of Darkness')
INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='The Left Hand of Darkness'
AND genres.genre='Female Author';

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='The Left Hand of Darkness'
AND genres.genre='Classic';

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

INSERT INTO book_genre
SELECT books.id, genres.id
FROM books
CROSS JOIN genres
WHERE books.title='Kushiel''s Dart'
AND genres.genre='Strong Female Lead';

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
--('Neuromancer'), William Gibson
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Neuromancer'
AND authors.author='William Gibson';

--('1984'),
INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='1984'
AND authors.author='George Orwell';

INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Hyperion'
AND authors.author='Dan Simmons';

INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='Fahrenheit 451'
AND authors.author='Ray Bradbury';

INSERT INTO book_author
SELECT books.id, authors.id
FROM books
CROSS JOIN authors
WHERE books.title='The Left Hand of Darkness'
AND authors.author='Ursula K Le Guin';

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
AND authors.author='Terry Prachett';

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

