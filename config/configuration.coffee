process.env.NODE_ENV = process.env.NODE_ENV?.toLowerCase() ? 'development'

class Config
  port: 80

class Config.development extends Config
  port: 3009
  redis:
    host: 'localhost'

module.exports = new Config[process.env.NODE_ENV]()