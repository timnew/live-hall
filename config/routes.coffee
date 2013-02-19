exports = module.exports = (app) ->
  app.get '/live', Routes.live.subscribe
  app.post '/live', Routes.live.publish
  
 