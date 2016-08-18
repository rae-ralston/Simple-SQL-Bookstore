var pgp = require('pg-promise')();
var connectionString = `postgres://${process.env.USER}@localhost:5432/bookstore`
var db = pgp(connectionString)

const getAllBooks = function(page){
  const offset = (page-1) * 10;
  console.log("select * from books LIMIT 10 OFFSET "+offset)
  return db.any("select * from books LIMIT 10 OFFSET $1", [offset])
}

const getAllGenres = function(){
  return db.any("select * from genres")
}

const getBookById = function(bookId){
  return db.one("select * from books where books.id=$1", [bookId])
}

const getGenresByBookId = function(bookId){
  const sql =  `
    SELECT
      genres.*,
      book_genre.book_id
    FROM
      genres
    JOIN
      book_genre
    ON
      genres.id = book_genre.genre_id
    WHERE
      book_genre.book_id IN ($1:csv)
  `;
  return db.many(sql, [bookId]);
}

const getAuthorsByBookId = function(bookId){
  const sql = `
    SELECT
      authors.*,
      book_author.book_id
    FROM
      authors
    JOIN
      book_author
    ON
      authors.id = book_author.author_id
    WHERE
      book_author.book_id IN ($1:csv)
  `;
  return db.any(sql, [bookId])
}


///////////////////////////// SEARCH
const searchForBooks = function(options){
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
  console.log('---nope-->', sql, variables)
  //looks like this isn't getting past here?
  return db.any(sql, variables)
    .then(books => {
      return Promise.all([
        getGenresForBooks(books),
        getAuthorsForBooks(books)
      ])
      .then(results => {
        const genres = results[0]
        const authors = results[1]
        console.log('books', books)
        console.log('genres', genres)
        console.log('authors', authors)

        books.forEach(book => {
          book.authors = authors.filter(author =>
            author.book_id === book.id
          )
        })

        return books
      })
    })
}

const getGenresForBooks = function(books){
  const genreIds = genres.map(genre => genre.id)
  const sql = `
    SELECT 
      genres.*,
      book_genre.book_id
    FROM 
      genres
    JOIN 
      book_genres
    ON 
      genres.id=book_genre.genre_id
    WHERE
      book_genre.book_id IN ($1:csv)
  `
  console.log('GenreID ---> ', typeof genreIds)
  return db.any(sql, [genreIds])
}

const getAuthorsForBooks = function(books){
  const bookIds = books.map(book => book.id)
  const sql = `
    SELECT
      authors.*,
      book_author.book_id
    FROM
      authors
    JOIN
      book_author
    ON
      authors.id=book_author.author_id
    WHERE
      book_author.book_id IN ($1:csv)
  `
  console.log('bookIds ---> ', typeof bookIds)
  return db.any(sql, [bookIds])
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
    return book
  })
}

const getAllBooksWithAuthorsAndGenres = function(){
  return getAllBooks().then(function(books){
    const bookIds = books.map(book => book.id)

    return Promise.all([
      getGenresByBookId(bookIds),
      getAuthorsByBookId(bookIds),
    ]).then(function(data){
      const genres = data[0]
      const authors = data[1]
      books.forEach(function(book){
        book.authors = authors.filter(author => author.book_id === book.id)
        book.genres = genres.filter(genre => genre.book_id === book.id)
      })
      return books
    })
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
  getAllBooksWithAuthorsAndGenres: getAllBooksWithAuthorsAndGenres,
  getGenresForBooks: getGenresForBooks,
  getAuthorsByBookId: getAuthorsByBookId,
}
