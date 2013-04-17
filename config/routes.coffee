exports = module.exports = (app) ->
  app.get '/', Routes.home.index

  app.get '/room/new', Routes.room.new.view
  app.post '/room/new', Routes.room.new

  app.get '/room/:roomId/edit', Routes.room.edit.view
  app.post '/room/:roomId/edit', Routes.room.edit
  app.get '/room/:roomId/presenter', Routes.room.presenter
  app.get '/room/:roomId/lockdown/:action', Routes.room.lockdown
  app.get '/room/:roomId/lockdown', Routes.room.lockdown.view


  app.get '/room/:roomId', Routes.room.get
  app.get '/room', Routes.room.list

  app.get '/slides/new', Routes.slides.new.view
  app.post '/slides/new', Routes.slides.new

  app.get '/slides/:slidesId/edit', Routes.slides.edit.view
  app.post '/slides/:slidesId/edit', Routes.slides.edit

  app.get '/slides', Routes.slides.list

  app.get '/view/:roomId/status', Routes.presentation.status
  app.get '/view/:roomId/progress', Routes.presentation.subscribeProgress
  app.post '/view/:roomId/progress', Routes.presentation.publishProgress
  app.get '/view/:roomId', Routes.presentation.view

  app.get '/launch/:roomId', Routes.presentation.launch



  
