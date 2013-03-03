global = this

return if @Widget?

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

  findSubWidgets: (selector = '[data-widget]') ->
    @findWidgets('find', selector)

  findSubWidget: (selector = '[data-widget]') ->
    @findWidget('find', selector)

  findParentWidget: (selector = '[data-widget]') ->
    @findWidget('parents', selector)

  findParentWidgets: (selector = '[data-widget]') ->
    @findWidgets('parents', selector)

  findSubWidgetsByType: (widgetType) ->
    @findWidgets('find', "[data-widget='#{widgetType}']")

  findSubWidgetByType: (widgetType) ->
    @findWidget('find', "[data-widget='#{widgetType}']")

  findParentWidgetByType: (widgetType) ->
    @findWidget('parents', "[data-widget='#{widgetType}']")

  findParentWidgetsByType: (widgetType) ->
    @findWidgets('parents', "[data-widget='#{widgetType}']")

  bindWidgetParts: (context = this, filter = '[data-widget-part]', attrName = 'data-widget-part') ->
    for part in @element.find(filter)
      $part = $(part)
      if $part.parents('[data-widget]:first')[0] == @element[0] # Should test Dom element instead of jQuery object
        name = $part.attr(attrName)
        context[name] = $part

    return

  bindActionHandlers: (selector="[data-action-handler]", context = this) ->
    @element.find(selector).on 'click', (e) =>
      handlerName = $(e.currentTarget).data('actionHandler')
      return console.warn("Action handler \"#{handlerName}\" doesn't exist in widget \"#{this.constructor.name}\"") unless handlerName?
      e.stopPropagation()
      context[handlerName].call(context, e)

ContainerMethods =
  register: (widget, widgetType = null) ->
    widgetType = widget.prototype.widgetType ? widget.name unless widgetType
    @namespace[widgetType] = widget

  find: (widgetType, includeGlobal = true) ->
    widgetTypeNames = widgetType.split('.') if typeof(widgetType) is 'string'

    currentName = widgetTypeNames.shift()
    if includeGlobal
      widget = @namespace[currentName] ? global[currentName]
    else
      widget = @namespace[currentName]

    return widget if widgetTypeNames.length == 0

    return null unless widget?

    widget.find(widgetType, false)

  createNamespace: (name) ->
    @namespace = []
    @namespace.name = name
    this

  findInNamespaces: (name, $dom) ->
    if name[0] == '@'
      isRelative = true
      name = name[1..]
    else
      isRelative = false

    result = Widget.find(name)
    return result if result?

    return null unless isRelative

    lastNamespace = Widget.namespace.name

    for parentDom in $dom.parents('[data-widget]')
      containerWidget = $(parentDom).data('widget').constructor

      if lastNamespace == containerWidget.namespace.name
        continue
      else
        result = containerWidget.find(name, false)
        return result if result?

WidgetLocateMethods =
  findWidget: (selector = '[data-widget]') ->
    $(selector).data('widget')

  findWidgets: (selector = '[data-widget]') ->
    $(item).data('widget') for item in $(selector)

  findWidgetByType: (widgetType) ->
    $("[data-widget='#{widgetType}']").data('widget')

  findWidgetsByType: (widgetType) ->
    $(item).data('widget') for item in $("[data-widget='#{widgetType}']")

WidgetClassMethods =
  activateOnReady: ->
    $ ->
      Widget.activateWidgets()

  activateWidgets: (scope = null) ->
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

      unless typeof(widgetType) is 'string'
        console.warn 'WARNING: Widget is initialized', $this
        return

      widgetConstructor = Widget.findInNamespaces(widgetType, $this)

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

$.extend Widget, ContainerMethods, WidgetClassMethods, WidgetLocateMethods

Widget
  .createNamespace('')
  .activateOnReady()
