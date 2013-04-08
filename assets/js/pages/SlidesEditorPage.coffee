#= require ../widgets/widget
#= require ../widgets/FormWidget

class @SlidesEditorPage extends Widget
  enhancePage: ->
    @bindActionHandlers()
    @slidesInfoRoom = @findSubWidgetByType('@SlidesInfoForm')

  submitSlidesInfo: ->
    @slidesInfoRoom.submit()

class SlidesInfoForm extends FormWidget
  bindDom: ->
    @inputs = @findSubWidgetsByType('@Input')

  validate: ->
    super(@inputs)

SlidesEditorPage
  .createNamespace('SlidesEditorPage')
  .register(SlidesInfoForm, 'SlidesInfoForm')