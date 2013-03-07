#= require ../widgets/widget
#= require ../widgets/FormWidget

class @LogInPage extends Widget
  bindDom: ->
    @tokenLogInForm = @findSubWidgetByType('@TokenLogInForm')

  enhancePage: ->
    @bindActionHandlers()

  login: ->
    @tokenLogInForm.simulate(true)

  fail: ->
    @tokenLogInForm.simulate(false)

class TokenLogInForm extends FormWidget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')
    @inputs = @findSubWidgetsByType('@Input')

  validate: ->
    super(@inputs)

  simulate: (correct)->
    window.i = @inputs
    if correct
      @inputs[0].value('correct')
    else
      @inputs[0].value('wrong')

    @ajaxSubmit()
      .always =>
        @sideview.updateView('edit')


LogInPage
  .createNamespace('Loginpage')
  .register(TokenLogInForm,'TokenLogInForm')