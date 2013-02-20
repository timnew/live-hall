exports.view = (req, res) ->
  template = req.query.template ? 'deckjs'
  console.log "Template Engine: #{template}"

  res.render "#{template}/view"

exports.control = (req, res) ->
  template = req.query.template ? 'deckjs'
  console.log "Template Engine: #{template}"

  res.render "#{template}/control"