viewEngines =
  'deck': 'deckjs'
  'deckjs': 'deckjs'
  'reveal': 'revealjs'
  'revealjs': 'revealjs'

exports.index = (req, res) ->
  options =
    id: req.params[0]
    engine: viewEngines[req.params[1] ? 'deck']
    control: !!req.query.control or req.query.control == ''

  console.log options

  return req.send 404 unless options.engine?

  res.render "#{options.engine}/view", options