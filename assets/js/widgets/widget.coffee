global = this

class @Widget
  constructor: (@element) ->
    @element.data('widget', this)

  bindDom: ->
  enhancePage: ->
  initialize: ->

  findWidgets: (finder, selector) ->
    $(item).data('widget') for item in @element[finder].call(@element, selector)

  findWidget: (finder, selector) ->
    @element[finder].call(@element, selector).data('widget')

  findSubWidgets: (selector) ->
    @findWidgets('find', selector)

  findSubWidget: (selector) ->
    @findWidget('find', selector)

  findParentWidget: (selector) ->
    @findWidget('parents', selector)

  findSubWidgetsByType: (widgetType) ->
    @findWidgets('find', "[data-widget='#{widgetType}']")

  findSubWidgetByType: (widgetType) ->
    @findWidget('find', "[data-widget='#{widgetType}']")

  findParentWidgetByType: (widgetType) ->
    @findWidget('parents', "[data-widget='#{widgetType}']")

  bindActionHandlers: (selector="[data-action-handler]", context = this) ->
    @element.find(selector).on 'click', (e) =>
      handlerName = $(e.currentTarget).data('actionHandler')
      return console.warn("Action handler \"#{handlerName}\" doesn't exist in widget \"#{this.constructor.name}\"") unless handlerName?
      e.stopPropagation()
      context[handlerName].call(context, e)

ContainerMethods =
  widgets:
    {}

  register: (widget, name = null) ->
    name = widget.name unless name?
    Widget.widgets[name] = widget

  find: (name, includeGlobal = true) ->
    name = name.split('.') if name.constructor is String

    currentName = name.shift()
    if includeGlobal
      widget = this.widgets[currentName] ? global[currentName]
    else
      widget = this.widgets[currentName]

    return widget if name.length == 0

    return null unless widget?

    widget.find(name, false)

WidgetLocateMethods =
  findWidget: (selector) ->
    $(selector).data('widget')

  findWidgets: (selector) ->
    $(item).data('widget') for item in $(selector)

  findWidgetByType: (widgetType) ->
    $("[data-widget='#{widgetType}']").data('widget')

  findWidgetsByType: (widgetType) ->
    $(item).data('widget') for item in $("[data-widget='#{widgetType}']")


WidgetClassMethods =
  loadOnReady: ->
    $ ->
      Widget.buildWidgets()

  buildWidgets: (scope = null) ->
    unless scope?
      scope = $('body')
    else if scope instanceof String
      scope = $(scope)
    unless scope instanceof jQuery
      console.error "ERROR: Unknown Scope", scope

    widgets = []

    scope.find('[data-widget]').each ->
      $this = $(this)
      widgetType = $this.data('widget')

      unless widgetType?
        console.error "ERROR: Widget name is empty", $this
        return

      unless widgetType.constructor is String
        console.warn 'WARNING: Widget is initialized', $this
        return

      widgetConstructor = Widget.find(widgetType)

      if widgetConstructor
        widgets.push new widgetConstructor($this)
      else
        console.error "ERROR: Unknown widget #{widgetType}", $this

    for widget in widgets
      widget.bindDom()

    for widget in widgets
      widget.enhancePage()

    for widget in widgets
      widget.initialize()

  enableContainer: (widget) ->
    $.extend widget, ContainerMethods

$.extend Widget, ContainerMethods, WidgetClassMethods, WidgetLocateMethods

Widget.loadOnReady()
