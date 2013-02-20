exports = module.exports = (app) ->
  app.get '/live', Routes.live.subscribe
  app.post '/live', Routes.live.publish
  app.get '/view', Routes.presentation.view
  app.get '/control', Routes.presentation.control

  
 