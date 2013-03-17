exports = module.exports = (app) ->
  app.get '/', Routes.slides.list


  app.get '/live/:roomId', Routes.live.subscribe
  app.post '/live/:roomId', Routes.live.publish

  #  app.get /^\/view\/(\w+)(?:\.(\w+))?(?:[#?].*)?$/, Routes.presentation.index # /test/:id.:type | /test/:id
  app.get '/view/:roomId', Routes.view.index



  
