#= require ./SideShowWidget

class SideView extends Widget.widgets.SideShow
  bindDom: ->
    super()
    @views = {}
    @views[$(view).data('sideview')] = $(view) for view in @element.find('[data-sideview]')

  enhancePage: ->
    super()
    @element.on 'show', =>
      @loadView()

  loadView: (url) ->
    url ?= @element.data('viewUrl')
    @activeView('loading')

    console.log "Loading from #{url}"
    $.get url, (viewHtml) =>
      @updateView viewHtml

  updateView: (viewHtml, viewName) ->
    $view = $(viewHtml)
    viewName ?= $view.data('sideview') ? 'content'
    @views[viewName].html('').append($view)
    @activeView(viewName)

  activeView: (name = 'loading') ->
    console.log "Active View #{name}"
    view.hide() for viewName, view of @views if viewName != name
    @views[name].show()

Widget.register SideView, "SideView"

###
.sideshow.hide(data-widget="SideShow")
  .sideview(data-sideview="loading").loading-indicator
  .sideview(data-sideview="content")
###