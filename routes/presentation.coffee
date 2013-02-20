exports.view = (req, res) ->
  template = req.params.template ? 'deckjs'
  res.render "#{template}/view"

exports.control = (req, res) ->
  template = req.params.template ? 'deckjs'
  res.render "#{template}/control"