exports = module.exports = (app) ->
  app.get '/', Routes.home.index

  app.get '/room/create', Routes.room.create.view
  app.post '/room/create', Routes.room.create

  app.get '/room/:roomId/edit', Routes.room.edit.view
  app.post '/room/:roomId/edit', Routes.room.edit
  app.get '/room/:roomId/presenter', Routes.room.presenter

  app.get '/room/:roomId', Routes.room.get
  app.get '/room', Routes.room.list


  app.get '/slides/new', Routes.slides.new.view
  app.post '/slides/new', Routes.slides.new

  app.get '/slides', Routes.slides.list

  app.get '/live/:roomId', Routes.live.subscribe
  app.post '/live/:roomId', Routes.live.publish

  app.get '/view/:roomId', Routes.view.index



  
