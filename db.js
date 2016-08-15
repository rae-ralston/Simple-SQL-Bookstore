var pgp = require('pg-promise')();
var connectionString = `postgres://${process.env.USER}@localhost:5432/bookstore`
var db = pgp(connectionString)

const getAllBooks = function(){
  return db.any("select * from book")  
}

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
  return db.one(sql, [bookId])
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
      book_author.genre_id=genre.id
    WHERE
      book_author.book_id=$1;
  `
  return db.one(sql, [bookId])
}

const getBookAndAuthorsAndGenresByBookId = function(bookId){
  return Promise.all([
    getBookById(bookId),
    getGenresByBookId(bookId),
    getAuthorsByBookId(bookId),
  ]).then(function(data){
    console.log('DATA???', data)
  })
}

module.exports = {
  pgp: pgp,
  db: db,
  getAllBooks: getAllBooks,
  getBookById: getBookById,
}
