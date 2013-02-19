_ = require('underscore')

config = {}

#TODO make the configuration is built when needed

config['common'] =
  port: 80

config['development'] =
  port: 3009

_.extend exports, config.common

specificConfig = config[process.env.NODE_ENV ? 'development']

if specificConfig?
  _.extend exports, specificConfig
