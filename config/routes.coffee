exports = module.exports = (app) ->
  app.get '/', Routes.slides.list

  app.get '/slides/new', Routes.slides.new.view
  app.post '/slides/new', Routes.slides.new


  app.get '/live/:roomId', Routes.live.subscribe
  app.post '/live/:roomId', Routes.live.publish

  app.get '/view/:roomId', Routes.view.index



  
