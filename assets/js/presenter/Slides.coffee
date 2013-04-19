#= require ../widgets/widget

wrapHook = (hook) ->
  (e) ->
    data = JSON.parse(e.data)
    console.log "Recieved Event: [#{e.type}]: ", data
    hook(data, e.type, e)

class @Slides extends Widget
  bindDom: ->
    @roomId = @element.data('room')
    @eventUrl = "/view/#{@roomId}/events"

  isPresenter: false

  enhancePage: ->
    @bindActionHandlers()
    @eventSource = new EventSource(@eventUrl)
    @hookEvents()

  initialize: ->
    @updateNote(@element.data('note'), false)

  publish: (event, data) ->
    console.log "Publish Event: [#{event}]: ", data
    $.post @eventUrl,
           event: event
           data: data

  hookEvent: (event, hook) ->
    @eventSource.addEventListener event, wrapHook(hook)

  hookEvents: (host = this) ->
    for name, hook of host
      continue unless typeof(hook) is 'function'
      capture = name.match /^(\w+)Hook/
      continue unless capture?
      @eventSource.addEventListener capture[1], wrapHook(hook)

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