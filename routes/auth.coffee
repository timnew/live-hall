exports.checkAuth = (action) ->
  return (req, res) ->
    if req.session.user?
      action(req, res)
    else
      res.redirect "/room/#{req.params.roomId}/login"

exports.login = (req, res) ->
  if req.body.correct
    req.session.user = 'xxx'
    res.send(200, 'true')
  else
    res.send(403, 'false')

exports.login.sideview = (req, res) ->
  res.render 'room/login'

exports.logout = (req, res) ->
  delete req.session.user
  res.send(200)