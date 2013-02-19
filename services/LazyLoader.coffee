_ = require('underscore')
path = require('path')
fs = require('fs')

class LazyLoader
  constructor: (@__rootPath) ->
    files = fs.readdirSync(@__rootPath)

    @__names = []
    _.forEach files, (file) =>
      extName = path.extname file
      if require.extensions[extName]?
        name = path.basename file, extName
        fullname = path.join(@__rootPath, file)
        @__names.push name
        Object.defineProperty this, name,
          get: ->
            require(fullname)

createLazyLoader = (rootPath) ->
  new LazyLoader(rootPath)

createLazyLoader.LazyLoader = LazyLoader

exports = module.exports = createLazyLoader
