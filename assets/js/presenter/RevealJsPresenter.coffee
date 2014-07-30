#= require ./RevealJsViewer

class @SlidesPresenter extends SlidesViewer
  isPresenter: true

  enhancePage: ->
    super()
    Reveal.addEventListener 'slidechanged', @onSlideChanged
    Reveal.addEventListener 'fragmentshown', @onSlideChanged
    Reveal.addEventListener 'fragmenthidden', @onSlideChanged
      

  onSlideChanged: =>
    indices = Reveal.getIndices()

    @publishEvent 'slidesProgress', indices      