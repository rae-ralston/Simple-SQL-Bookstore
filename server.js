var express = require('express');
var database = require('./db');
var bodyParser = require('body-parser');

var app = express();

app.set('view engine', 'pug');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.get('/', (req,res) => {
  database.getAllGenres()
    .then(function(genres){
      res.render('index')
    })
    .catch(function(error){
      throw error
    })
})

app.get('/books', (req,res) => {
  let page = parseInt(req.query.page, 10);
  if (isNaN(page)) page = 1;

  database.getAllBooks(page)
    .catch(function(error){
      res.render('error',{error:error})
    })
    .then(function(books){
      res.render('books/index', {
        page: page,
        books: books
      })
    })

});

app.get('/books/new', (req,res) => {
  database.getAllGenres()
    .then(function(genres){
      res.render('books/new', {
        genres: genres
      })
    })
    .catch(function(error){
      throw error
    })
});

app.get('/books/:book_id', (req,res) => {
  database.getBookAndAuthorsAndGenresByBookId(req.params.book_id)
   .then(function(book){
      res.render('books/show', {
        book: book
      })
    })
    .catch(function(error){
      throw error
    })
});

app.post('/books', (req,res) =>{
  console.log(req.body)
  database.createBook(req.body.book)
    .catch(function(error){
      renderError(res, error)
    })
    .then(function(bookId){
      res.redirect('/books/'+bookId)
    })

})

app.get('/test', function(req, res){
  database.getAllBooksWithAuthorsAndGenres()
    .then(function(data){
      res.json(data)
    })
})

const renderError = function(res, error){
  res.status(500).render('error', {error: error})
  throw error
}


var port = Number( process.env.PORT || 5000 );

app.listen(port, function() {
  console.log('http://localhost:' + port)
})
