#= require ./SideShowWidget

class SideView extends Widget.widgets.SideShow
  bindDom: ->
    super()
    @views = {}
    @views[$(view).data('sideview')] = $(view) for view in @element.find('[data-sideview]')

  ensureViewExists: (viewName, viewTemplate) ->
    view = @views[viewName]

    unless view?
      viewTemplate = "<div class=\"sideview\" data-sideview=\"#{viewName}\">" unless viewTemplate?
      console.log "Create Side View #{viewname}..."
      view = @views[viewName] = $(viewTemplate).appendTo(@element)

    view

  updateView: (viewName) ->
    view = @views[viewName]
    return console.error "Side View #{viewName} doesn't exists." unless view?

    url = view.attr('href')
    return console.error "Side View #{viewName} doesn't have href attribute." unless url?

    @updateViewFromUrl(url, viewName)

  updateViewFromUrl: (url, viewName) ->
    @activeLoadingView();

    console.log "Loading Side View from #{url}..."
    $.get url, (viewHtml) =>
      @updateViewFromHtml viewHtml, viewName

  updateViewFromHtml: (viewHtml, viewName) ->
    $view = $(viewHtml)

    viewName ?= $view.data('sideview') ? 'content' # Read viewName from the html if viewName is not provided, and fallback to "content"

    console.log "Updating Side View #{viewName}..."
    @ensureViewExists(viewName)
    @views[viewName].html('').append($view)

    @activeView(viewName)

  activeLoadingView: ->
    @activeView('loading')

  activeView: (name) ->
    console.log "Active Side View #{name}..."
    view.hide() for viewName, view of @views if viewName != name
    @views[name].show()

Widget.register SideView, "SideView"

###
.sideshow.hide(data-widget="SideShow")
  .sideview(data-sideview="loading")
    .loading-indicator
  .sideview(data-sideview="content")
###