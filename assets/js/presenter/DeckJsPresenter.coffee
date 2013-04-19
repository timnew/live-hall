#= require ./DeckJsViewer

class @SlidesPresenter extends SlidesViewer
  isPresenter: true

  enhancePage: ->
    super()
    $(document).bind('deck.change', @onSlideChanged)

  onSlideChanged: (event, from, to) =>
    return unless @currentPage != to

    @currentPage = to

    @publishEvent 'slidesProgress',
      from: from
      to: to