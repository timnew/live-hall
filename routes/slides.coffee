exports.list = (req, res) ->
  res.render('slides/list')

exports.new = (req, res) ->
  raise 'not impelemented'

exports.new.view = (req, res) ->
  res.render('slides/new')