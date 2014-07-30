#= require ./RevealJsViewer

class @SlidesPresenter extends SlidesViewer
  isPresenter: true

  enhancePage: ->
    super()
    Reveal.addEventListener 'slidechanged', @onSlideChanged
    Reveal.addEventListener 'fragmentshown', =>
      @onFragmentChanged(1)
    Reveal.addEventListener 'fragmenthidden', =>
      @onFragmentChanged(-1)
      

  onSlideChanged: =>
    indices = Reveal.getIndices()

    @publishEvent 'slidesProgress', indices

  onFragmentChanged: (offset) =>
    indices = Reveal.getIndices()

    return @onSlideChanged() if indices.f?

    @publishEvent 'fragmentOffset', offset
