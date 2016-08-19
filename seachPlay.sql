

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

