process.env.NODE_ENV = 'test'

const expect = require('expect.js') //(google expect)
const database = require('../db')

describe('get all books', function() {

  beforeEach(()=> {
    return database.truncateAllTables()
  })

  it ('should get all books', function(){
    return database.getAllBooks()
      .then( books => {
        expect(books).to.be.a(Array)
        expect(books.length).to.eql(0)
      })
      .then( () => {
        return Promise.all([
          database.createBook({title: 'Book #1'}),
          database.createBook({title: 'Book #2'}),
          database.createBook({title: 'Book #3'}),
          database.createBook({title: 'Book #4'}),
        ])
      })
      .then( () => {
        return database.getAllBooks()
      })
      .then( books => {
        expect(books).to.be.a(Array)
        expect(books.length).to.eql(4)
        expect(books[0].title).to.eql('Book #1')
        expect(books[1].title).to.eql('Book #2')
        expect(books[2].title).to.eql('Book #3')
        expect(books[3].title).to.eql('Book #4')
      })

  })
})
