#= require ./RevealJsViewer

class @SlidesPresenter extends SlidesViewer
  enhancePage: ->
    super()
    Reveal.addEventListener 'slidechanged', @onSlideChanged

  onSlideChanged: (e) =>
    @publish 'slidesProgress',
      h: e.indexh
      v: e.indexv