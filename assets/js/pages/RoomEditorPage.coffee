#= require ../widgets/widget
#= require ../widgets/FormWidget

class @RoomEditorPage extends Widget
  enhancePage: ->
    @bindActionHandlers()
    @roomInfoForm = @findSubWidgetByType('@RoomInfoForm')

  submitRoomInfo: ->
    @roomInfoForm.submit()

class RoomInfoForm extends FormWidget
  bindDom: ->
    @inputs = @findSubWidgetsByType('@Input')

  validate: ->
    super(@inputs)

RoomEditorPage
  .createNamespace()
  .register(RoomInfoForm, 'RoomInfoForm')