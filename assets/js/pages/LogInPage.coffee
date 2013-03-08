#= require ../widgets/widget
#= require ../widgets/FormWidget

class @LogInPage extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')
    @tokenLogInForm = @findSubWidgetByType('@TokenLogInForm')

  enhancePage: ->
    @bindActionHandlers()

  initialize: ->
    @navigation = @element.data('navigation')

  signIn: ->
    @tokenLogInForm.signIn()

  next: ->
    @sideview.updateView(@navigation.nextView)

  back: ->
    @sideview.activateView(@navigation.previousView)

class TokenLogInForm extends FormWidget
  bindDom: ->
    @page = @findParentWidgetByType('LogInPage')
    @inputs = @findSubWidgetsByType('@Input')

  validate: ->
    super(@inputs)

  signIn: =>
    @ajaxSubmit()
      .always =>
        @page.next()


LogInPage
  .createNamespace('Loginpage')
  .register(TokenLogInForm,'TokenLogInForm')