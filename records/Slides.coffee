SlidesSchema = new Services.Repository.Schema
  name: String
  theme: String
  format: String
  content: String

SlidesSchema.methods.render = ->
  switch @format
    when 'jade'
      require('jade').compile(@content)()
    when 'html'
      @content

filterOptions =
  deckjs:
    class: (v) ->
      v && v.indexOf('slide') != -1
  revealjs:
    tag_name: "section"

SlidesSchema.methods.preview = ->
  htmlparser = require("htmlparser2")
  rawHtml = @render()
  result = null
  option = filterOptions[@theme]
  handler = new htmlparser.DefaultHandler (error, dom) ->
    if (error)
      result = null
    else
      slides = htmlparser.DomUtils.getElements option, dom
      result = htmlparser.DomUtils.getOuterHTML slides[0]

  parser = new htmlparser.Parser(handler)
  parser.parseComplete(rawHtml)

  result

Slides = Services.Repository.model 'Slides', SlidesSchema

module.exports = Slides

