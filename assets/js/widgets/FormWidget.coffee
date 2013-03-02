#= require ./widget

class @FormWidget extends Widget
  serialize: ->
    @element.serialize()

  submit: ->
    @element.submit() if @validate()

  reset: ->
    @element.reset()

  validate: (inputs) ->
    result = true

    for input in inputs
      result &= input.validate()

    result

FormWidget.createNamespace()

class InputWidget extends Widget
  bindDom: ->
    @errorMessage = $('<span class="help-inline hide">').appendTo @element.find('.controls')
    @input = @element.find('input')

  changeValidationState: (state = '', message) ->
    @element.removeClass('warning error info success')
    @errorMessage.hide()

    return if state == ''

    @element.addClass(state) if state in ['warning', 'error', 'info', 'success']

    if message?
      @errorMessage.text(message).show()

  validate: ->
    value = @input.val().trim()
    if value == ''
      @changeValidationState 'error', 'Cannot be empty'
      return false
    else
      @changeValidationState()
      return true

FormWidget.register InputWidget, 'Input'


#<div class="control-group warning" data-widget="@InputWidget">
#  <label class="control-label" for="inputWarning">Input with warning</label>
#  <div class="controls">
#    <input type="text" id="inputWarning">
#    <span class="help-inline">Something may have gone wrong</span>
#  </div>
#</div>

