#= require ../widgets/widget
#= require ../widgets/FormWidget

class @CreateRoomPage extends Widget
  enhancePage: ->
    @bindActionHandlers()
    @createRoomForm = @findSubWidgetByType('@CreateRoomForm')

  createRoom: ->
    @createRoomForm.submit()

CreateRoomPage.createNamespace()

class CreateRoomForm extends FormWidget
  bindDom: ->
    @inputs = @findSubWidgetsByType('@Input')

  validate: ->
    super(@inputs)

CreateRoomPage.register CreateRoomForm, 'CreateRoomForm'