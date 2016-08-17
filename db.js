var pgp = require('pg-promise')();
var connectionString = `postgres://${process.env.USER}@localhost:5432/bookstore`
var db = pgp(connectionString)

const getAllBooks = function(){
  return db.any("select * from books")  
}

const getAllGenres = function(){
  return db.any("select * from genres")  
}

const getBookById = function(bookId){
  return db.one("select * from books where books.id=$1", [bookId])
}

const getGenresByBookId = function(bookId){
  const sql = `
    SELECT
      DISTINCT(genres.*)
    FROM 
      genres
    JOIN
      book_genre
    ON
      book_genre.genre_id=genres.id
    WHERE
      book_genre.book_id=$1;
  `
  return db.any(sql, [bookId])
}

const getAuthorsByBookId = function(bookId){
    const sql = `
    SELECT
      DISTINCT(authors.*)
    FROM 
      authors
    JOIN
      book_author
    ON
      book_author.author_id=authors.id
    WHERE
      book_author.book_id=$1;
  `
  return db.any(sql, [bookId])
}


///////////////////////////// SEARCH
const searchForBooks = function(options){




  console.log(options)
  const variables = []
  let sql = `
    SELECT 
      DISTINCT(books.*)
    FROM
      books
  `
  if (options.search_query){
    let search_query = options.search_query
      .toLowerCase()
      .replace(/^ */, '%')
      .replace(/ *$/, '%')
      .replace(/ +/g, '%')
    
    variables.push(search_query)
    sql += `
        WHERE
      LOWER(books.title) LIKE $${variables.length}
    `
  }
  console.log('----->', sql, variables)
  return db.any(sql, variables)
}


const searchForBook = searchTerm => {
  const sql = `
    SELECT
      DISTINCT(books.*)
    FROM 
      books
    JOIN 
      book_author
    ON 
      authors.id=book_author.author_id
    JOIN 
      books
    ON 
      book_author.book_id=books.id
    WHERE 
      authors.author LIKE '$1%';
  `
  return db.any(sql, [searchTerm])
}

const searchForAuthor = searchTerm => {
  const sql = `
    SELECT
      DISTINCT(authors.*)
    FROM 
      authors
    JOIN 
      book_author
    ON 
      books.id=book_author.book_id
    JOIN 
      authors
    ON 
      book_author.author_id=authors.id
    WHERE 
      authors.author LIKE '$1%';
  `
  return db.any(sql, [searchTerm])
}



///////////////////////////// CREATE AND ASSOCIATE

const createAuthor = function(attributes){
  console.log(attributes)
  const sql = `
    INSERT INTO
      authors (author)
    VALUES
      ($1)
    RETURNING
      id
  `
  return db.one(sql, [attributes.author])
}

const associateAuthorsWithBook = function(authorIds, bookId){
  authorIds = Array.isArray(authorIds) ? authorIds : [authorIds]
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
  genreIds = Array.isArray(genreIds) ? genreIds : [genreIds]
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
  const sql = `
    INSERT INTO
      books (title)
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
  getAllGenres: getAllGenres,
  createAuthor:createAuthor,
  searchForBooks:searchForBooks,
  getBookAndAuthorsAndGenresByBookId:getBookAndAuthorsAndGenresByBookId,
}
