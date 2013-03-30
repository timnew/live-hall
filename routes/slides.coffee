exports.list = (req, res) ->
  res.render('slides/list')

exports.new = (req, res) ->
  console.log req.body

  res.send 'ok'

exports.new.view = (req, res) ->
  res.render('slides/new')