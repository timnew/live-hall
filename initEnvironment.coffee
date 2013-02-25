global.createLazyLoader = require('./services/LazyLoader')
global.createPathHelper = require('./services/PathHelper')

global.rootPath = createPathHelper(__dirname).consolidate()

global.configuration = require(rootPath.config('configuration'))

global.Services = createLazyLoader rootPath.services()
global.Routes = createLazyLoader rootPath.routes()
global.Models = createLazyLoader rootPath.models()
