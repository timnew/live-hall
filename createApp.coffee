require('coffee-script')
require('./initEnvironment')

http = require('http')
express = require('express')

app = express()

app.configure ->
  app.set 'port', process.env.PORT || Configuration.port
  app.set 'views', rootPath.views()
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser(Configuration.cookieSecret)
  app.use express.session()
  app.use app.router

  app.use require('connect-assets') # customize this in production and heroku environment
    src: 'assets'
    helperContext: global.assets
    build: false
    detectChanges: true
    minifyBuilds: true
    pathsOnly: false

  app.use express.static rootPath.public()

app.configure 'development', ->
  app.use express.errorHandler()

app.configure 'test', ->
  app.use express.errorHandler()

require('./config/routes')(app)

exports = module.exports = app