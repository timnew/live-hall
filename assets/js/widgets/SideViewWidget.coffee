#= require ./SideShowWidget

class @SideView extends SideShow
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
    @activateLoadingView()

    console.log "Loading Side View from #{url}..."
    $.get url, (viewHtml) =>
      @updateViewFromHtml viewHtml, viewName

  updateViewFromCallback: (viewName, callback) ->
    if(arguments.length == 1)
      callback = viewName
      viewName = undefined

    @activateLoadingView()

    console.log "Loading Side View from Callback..."
    callback (viewHtml, newViewName) =>
      @updateViewFromHtml(viewHtml, newViewName ? viewName)

  updateViewFromHtml: (viewHtml, viewName) ->
    $view = $(viewHtml)

    viewName = $view.data('sideview') ? viewName ? 'content'

    console.log "Updating Side View #{viewName}..."
    @ensureViewExists(viewName)
    @views[viewName].html('').append($view)

    console.log "Activating Widgets for Side View..."
    Widget.activateWidgets @views[viewName] # Active widget if exists

    @activateView(viewName)

  activateLoadingView: ->
    @activateView('loading')

  activateView: (name) ->
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