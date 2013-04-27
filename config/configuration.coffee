process.env.NODE_ENV = process.env.NODE_ENV?.toLowerCase() ? 'development'

class Config
  port: 80
  cookieSecret: '!J@IOH$!BFBEI#KLjfelajf792fjdksi23989HKHD&&#^@'

class Config.development extends Config
  port: 3009
  redis:
    uri: 'redis://localhost:6379'
  mongo:
    uri: 'mongodb://localhost'

class Config.heroku extends Config
  redis:
    uri: process.env.REDISCLOUD_URL
  mongo:
    uri: process.env.MONGOLAB_URI
  cookieSecret: process.env.COOKIE_SECRET
    
module.exports = new Config[process.env.NODE_ENV]()