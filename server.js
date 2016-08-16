var express = require('express');
var database = require('./db');
var bodyParser = require("body-parser");

var app = express();

app.set('view engine', 'pug');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/', (req,res) => {
  res.render('index')
});

app.get('/books', (req,res) => {
  database.getAllBooks()
    .then(function(books){
      res.render('books/index', {
        books: books
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

app.post('/insert', (req,res) =>{
  const { title } = req.body  
  database.insertBook(title)
    .then(function(data){
      console.log(data)
    })
    .catch(function(error){
      throw error
    })
})


var port = Number( process.env.PORT || 5000 );

app.listen(port, function() {
  console.log('http://localhost:' + port)
})