#= require ../widgets/widget
#= require ../widgets/FormWidget

class @SlidesEditorPage extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')
  enhancePage: ->
    @bindActionHandlers()
    @slidesInfoRoom = @findSubWidgetByType('@SlidesInfoForm')

  submitSlidesInfo: ->
    @slidesInfoRoom
      .ajaxSubmit()
      .done =>
        @sideview.hide()

class SlidesInfoForm extends FormWidget
  bindDom: ->
    @inputs = @findSubWidgetsByType('@Input')

  validate: ->
    super(@inputs)

SlidesEditorPage
  .createNamespace('SlidesEditorPage')
  .register(SlidesInfoForm, 'SlidesInfoForm')