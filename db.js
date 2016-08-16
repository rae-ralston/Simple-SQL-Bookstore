var pgp = require('pg-promise')();
var connectionString = `postgres://${process.env.USER}@localhost:5432/bookstore`
var db = pgp(connectionString)

const getAllBooks = function(){
  return db.any("select * from book")  
}

//note the distince function creation for each kind of action.

const getBookById = function(bookId){
  return db.one("select * from book where book.id=$1", [bookId])
}

const getGenresByBookId = function(bookId){
  const sql = `
    SELECT
      DISTINCT(genre.*)
    FROM 
      genre
    JOIN
      book_genre
    ON
      book_genre.genre_id=genre.id
    WHERE
      book_genre.book_id=$1;
  `
  return db.any(sql, [bookId])
}

const getAuthorsByBookId = function(bookId){
    const sql = `
    SELECT
      DISTINCT(author.*)
    FROM 
      author
    JOIN
      book_author
    ON
      book_author.author_id=author.id
    WHERE
      book_author.book_id=$1;
  `
  return db.any(sql, [bookId])
}

const insertBook = function(title){
    const sql = `
    INSERT INTO
      book (title)
    VALUES
      ($1);
      `
  return db.one(sql, [title])
}

const getBookAndAuthorsAndGenresByBookId = function(bookId){
  return Promise.all([
    getBookById(bookId),
    getGenresByBookId(bookId),
    getAuthorsByBookId(bookId),
  ]).then(function(data){
    var book = data[0]
    book.authors=data[2]
    book.genres=data[1]
    console.log(book)
    return book
  }) 
}

const insertBookAndAuthors = function(authorFirst, authorLast, BookTitle){
  return Promise.all([
    getBookById(bookId),
    getGenresByBookId(bookId),
    getAuthorsByBookId(bookId),
  ]).then(function(data){
    var book = data[0]
    book.authors=data[2]
    book.genres=data[1]
    console.log(book)
    return book
  }) 
}


module.exports = {
  pgp: pgp,
  db: db,
  getAllBooks: getAllBooks,
  getBookById: getBookById,
  insertBook: insertBook,
  getBookAndAuthorsAndGenresByBookId:getBookAndAuthorsAndGenresByBookId,
}
