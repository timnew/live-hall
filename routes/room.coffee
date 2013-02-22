exports.get = (req, res) ->
  res.send 200

exports.create = (req, res) ->
  res.send 200

exports.create.post = (req,res) ->
  res.redirect "/room/123"

exports.public = (req, res) ->
  res.send 200