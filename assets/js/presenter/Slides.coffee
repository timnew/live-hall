#= require ../widgets/EventSourceWidget

class @Slides extends EventSourceWidget
  bindDom: ->
    @roomId = @element.data('room')
    @eventUrl = "/view/#{@roomId}/events"

  isPresenter: false

  enhancePage: ->
    @bindActionHandlers()
    @initEventSource(@eventUrl)
    @hookEvents()

  initialize: ->
    @updateNote(@element.data('note'), false)

  reloadSlidesHook: ->
    window.location.reload(true)

  changeNoteHook: (status) =>
    @updateNote(status.display == 'true', false)

  updateNote: (state, broadcast = true) ->
    return if @isNoteVisible == state

    @isNoteVisible = state

    if state
      @element.find('.note').show()
    else
      @element.find('.note').hide()

    if broadcast and @isPresenter
      @publish 'changeNote',
        display: !!@isNoteVisible

  toggleNote: (broadcast = true) =>
    @updateNote(!@isNoteVisible, broadcast)