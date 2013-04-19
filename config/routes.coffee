exports = module.exports = (app) ->
  app.get '/', Routes.home.index

  app.get '/room/new', Routes.room.new.view
  app.post '/room/new', Routes.room.new

  app.get '/room/:roomId/edit', Routes.room.edit.view
  app.post '/room/:roomId/edit', Routes.room.edit
  app.get '/room/:roomId/presenter', Routes.room.presenter
  app.get '/room/:roomId/lockdown/lock', Routes.room.lockdown.lockMeta
  app.post '/room/:roomId/lockdown/lock', Routes.room.lockdown.lock
  app.post '/room/:roomId/lockdown/unlock', Routes.room.lockdown.unlock
  app.get '/room/:roomId/lockdown', Routes.room.lockdown.view

  app.get '/room/:roomId', Routes.room.get
  app.get '/room', Routes.room.list

  app.get '/slides/new', Routes.slides.new.view
  app.post '/slides/new', Routes.slides.new

  app.get '/slides/:slidesId/edit', Routes.slides.edit.view
  app.post '/slides/:slidesId/edit', Routes.slides.edit

  app.get '/slides', Routes.slides.list

  app.get '/view/:roomId/events', Routes.presentation.subscribeEvents
  app.post '/view/:roomId/events', Routes.presentation.publishEvents
  app.get '/view/:roomId', Routes.presentation.view

  app.get '/launch/:roomId', Routes.presentation.launch



  
