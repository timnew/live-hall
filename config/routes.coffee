exports = module.exports = (app) ->
  app.get '/', Routes.home.index
  app.get '/live', Routes.live.subscribe
  app.post '/live', Routes.live.publish
  app.get /^\/view\/(\w+)(?:\.(\w+))?(?:[#?].*)?$/, Routes.presentation.index # /test/:id.:type | /test/:id

  
