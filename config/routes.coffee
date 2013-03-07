exports = module.exports = (app) ->
  app.get '/', Routes.home.index

  app.get '/room/create', Routes.room.create.view
  app.post '/room/create', Routes.room.create
  app.get '/room/public', Routes.room.public

  app.get '/room/:roomId/edit', Routes.room.edit.view
  app.post '/room/:roomId/edit', Routes.room.edit

  app.get '/room/:roomId/presenter', Routes.room.presenter

  app.get '/room/:roomId/login/sideview', Routes.auth.login.sideview
  app.get '/room/:roomId/login', Routes.auth.login

  app.get '/logout', Routes.auth.logout

  app.get '/room/:roomId', Routes.room.get


  app.get '/live/:roomId', Routes.live.subscribe
  app.post '/live/:roomId', Routes.live.publish

  #  app.get /^\/view\/(\w+)(?:\.(\w+))?(?:[#?].*)?$/, Routes.presentation.index # /test/:id.:type | /test/:id
  app.get '/view/:roomId', Routes.view.index



  
