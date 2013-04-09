#= require ./widget
# require ../jQuery/jQuery.ajaxJson.js

class @FormWidget extends Widget
  serialize: ->
    @element.serializeJson()

  serializeParam: ->
    @element.serialize()

  ajaxSubmit: ->
    unless @validate()
      return {
        done: ->
        fail: ->
        always: ->
        then: ->
      }

    method = @element.attr('method')?.toUpperCase() ? 'GET'
    url = @element.attr('action')

    switch method
      when 'GET'
        $.get url, @serializeParam()
      when 'POST'
        $.postJson url, @serialize()
      else
        throw "Unknown Method \"#{method}\""

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

  value: ->
    @input.val.apply(@input, arguments)

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

