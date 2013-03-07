#= require ../widgets/widget
#= require ../widgets/FormWidget

class @LogInPage extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  submit: (correct) ->
    $.postJson '/room/1/login', {correct: correct}, =>
      @sideview.updateView('edit')

  login: ->
    @submit true

  fail: ->
    @submit false