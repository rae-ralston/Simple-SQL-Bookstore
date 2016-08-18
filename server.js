"use strict";
/* globals console, process, require: true */
var express = require('express');
var database = require('./db');
var bodyParser = require('body-parser');

var app = express();

app.set('view engine', 'pug');

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());


const renderError = function(res){
  return function(error){
    res.render('error',{error:error})
    throw error
  }
}

app.get('/', (req,res) => {
  let page = parseInt(req.query.page, 10);
  if (isNaN(page)) page = 1;
  let searchOptions = {
    page: page,
    search_query:req.query.search_query,
  }
  database.searchForBooks(searchOptions)
    .catch(renderError(res))
    .then(function(books){
      res.render('books/index', {
        page: page,
        books: books
      });
    });
});

app.get('/books/new', (req,res) => {
  database.getAllGenres()
    .catch(renderError(res))
    .then(function(genres){
      res.render('books/new', {
        genres: genres
      });
    })
    .catch(renderError(res))
});

app.get('/books/:book_id', (req,res) => {
  database.getBookAndAuthorsAndGenresByBookId(req.params.book_id)
   .then(function(book){
      res.render('books/show', {
        book: book
      });
    })
    .catch(renderError(res))
});

app.post('/books', (req,res) =>{
  console.log(req.body);
  database.createBook(req.body.book)
    .then(function(bookId){   
      res.redirect('/books/'+bookId);
    })
    .catch(renderError(res))
});

app.get('/test', function(req, res){
  database.getAllBooksWithAuthorsAndGenres()
    .then(function(data){
      res.json(data);
    })
    .catch(renderError(res))
});


var port = Number( process.env.PORT || 5000 );

app.listen(port, function() {
  console.log('http://localhost:' + port);
});

