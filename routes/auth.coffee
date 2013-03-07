exports.checkAuth = (action) ->
  return (req, res) ->
    if req.session.auth?[req.params.roomId]
      action(req, res)
    else
      res.redirect "/room/#{req.params.roomId}/login/sideview"

exports.login = (req, res) ->
  console.log req.query
  if req.query.token == 'correct'
    req.session.auth ?= {}
    req.session.auth[req.params.roomId] = true
    res.send(200, 'true')
  else
    res.send(403, 'false')

exports.login.sideview = (req, res) ->
  res.render 'room/login',
    roomId: req.params.roomId

exports.logout = (req, res) ->
  delete req.session.auth
  res.send(200)