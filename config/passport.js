var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy
var ObjectId = require( 'objectid' )
var md5 = require('blueimp-md5')

var db = require('./db')

module.exports = function() {
  passport.serializeUser( function( user, done ) {
    done( null, { 
      email: user.username, 
      _id: user._id, 
      email_hash: md5( user.username.toLowerCase() ) } 
    );
  });

  passport.deserializeUser( function( user, done ) {
    var connection = db.get()

    connection.collection( 'users' ).findOne({ _id: ObjectId( user._id ) }, function( error, user ) {
      done( error, user )
    })
  });

  passport.use( new LocalStrategy (
    function( username, password, done ) {
      var connection = db.get()

      connection.collection( 'users' ).findOne({ username: username }, function( error, user ) {
        if ( error ) { 
          return done( error ); 
        }

        if ( !user ) {
          return done( null, false, { message: 'Incorrect username.' });
        }

        // TODO: This is insecure since password not encrypted, and
        // telling user password is bad. Fix.
        if ( user.password !== password ) {
          return done( null, false, { message: 'Incorrect password.' });
        }

        return done( null, user );
      })
    }
  ));
}