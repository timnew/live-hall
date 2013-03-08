exports.checkAuth = (back, to, action) ->
  return (req, res) ->
    if req.session.auth?[req.params.roomId]
      action(req, res)
    else
      console.log req.headers
      res.redirect "/room/#{req.params.roomId}/login/sideview?back=#{back}&to=#{to}"

exports.login = (req, res) ->
  console.log req.query
  if req.query.token == 'correct'
    req.session.auth ?= {}
    req.session.auth[req.params.roomId] = true
    res.send(200, 'true')
  else
    res.send(403, 'false')

exports.login.sideview = (req, res) ->
  console.log req.query
  res.render 'room/login',
    roomId: req.params.roomId
    navigation: JSON.stringify {previousView: req.query.back, nextView: req.query.to}

exports.logout = (req, res) ->
  delete req.session.auth
  res.send(200)