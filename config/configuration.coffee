process.env.NODE_ENV = process.env.NODE_ENV?.toLowerCase() ? 'development'

class Config
  port: 80
  cookieSecret: '!J@IOH$!BFBEI#KLjfelajf792fjdksi23989HKHD&&#^@'

class Config.development extends Config
  port: 3009
  redis:
    host: 'localhost'
    port: 6379
  mongo:
    uri: 'mongodb://localhost'

class Config.heroku extends Config
  redis:
    host: "pub-redis-11399.us-east-1-4.3.ec2.garantiadata.com"
    port: 11399
    password: "YiwTZvduQHWSrzdm"
  mongo:
    uri: 'mongodb://livehall:livehall@ds043487.mongolab.com:43487/heroku_app12102144'

module.exports = new Config[process.env.NODE_ENV]()