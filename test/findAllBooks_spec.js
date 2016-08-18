process.env.NODE_ENV = 'test'

const expect = require('expect.js') //(google expect)
const database = require('../db')

descirbe('get all books', function() {
  it ('should get all books', function(){
    return database.getAllBooks(all)
      .then( thing => {
        expect(books.title).not.to.be(undefined)
    })
  })
})
