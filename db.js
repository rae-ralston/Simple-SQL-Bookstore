var pgp = require('pg-promise')();
var connectionString = `postgres://${process.env.USER}@localhost:5432/bookstore`
var db = pgp(connectionString)

const getAllBooks = function(){
  return db.any("select * from book")  
}

const getAllGenres = function(){
  return db.any("select * from genre")  
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

// make a from
// query strig syntaxt so form submits data i correct format
// get ojbect with string, pass into
// const searchForBook()
// where book title is like this
// or author.name is like this



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

const createAuthor = function(attributes){
  console.log(attributes)
  const sql = `
    INSERT INTO
      author (first_name, last_name)
    VALUES
      ($1, $2)
    RETURNING
      id
  `
  return db.one(sql, [attributes.first_name, attributes.last_name])
}

const associateAuthorsWithBook = function(authorIds, bookId){
  let queries = authorIds.map(authorId => {
    const sql = `
      INSERT INTO
        book_author (book_id, author_id)
      VALUES
        ($1, $2)
    `
    return db.none(sql, [bookId, authorId])
  })
  return Promise.all(queries)
}

const associateGenresWithBook = function(genreIds, bookId){
  let queries = genreIds.map(genreId => { 
    let sql = `
      INSERT INTO
        book_genre (book_id, genre_id)
      VALUES
        ($1, $2)
    `
    return db.none(sql, [bookId, genreId])
  })
  return Promise.all(queries)
}


const createBook = function(attributes){
  console.log(attributes)
  const sql = `
    INSERT INTO
      book (title)
    VALUES
      ($1)
    RETURNING
      id
  `
  var queries = [
    db.one(sql, [attributes.title]) // create the book
  ]
  // also create the authors
  attributes.authors.forEach(author =>
    queries.push(createAuthor(author))
  )

  return Promise.all(queries)
    .then(authorIds => {
      authorIds = authorIds.map(x => x.id)
      const bookId = authorIds.shift()
      return Promise.all([
        associateAuthorsWithBook(authorIds, bookId),
        associateGenresWithBook(attributes.genres, bookId),
      ]).then(function(){
        return bookId;
      })
    })
}

const authorLastName = function(first_name, last_name){
  const sql = `
    INSERT INTO
      author (first_name, last_name)
    VALUES
      ($1, $2);
      `
  return db.one(sql, [first_name, last_name])
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



module.exports = {
  pgp: pgp,
  db: db,
  getAllBooks: getAllBooks,
  getBookById: getBookById,
  createBook: createBook,
  authorLastName: authorLastName,
  getAllGenres: getAllGenres,
  createAuthor:createAuthor,
  getBookAndAuthorsAndGenresByBookId:getBookAndAuthorsAndGenresByBookId,
}
