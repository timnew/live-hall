#= require ../widgets/EventSourceWidget
#= require ../leap/leap.js

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

    @initLeapMotionController()

  initLeapMotionController: ->     
    Leap.loop { enableGestures: true }, (frame) =>
      return if frame.gestures.length is 0

      for gesture in frame.gestures
        @onLeapGesture gesture, frame

  onLeapGesture: (gesture, frame) ->

  gestureAllowed: true  

  gestureCooled: =>
    @gestureAllowed = true

  gestureAccepted: ->
    @gestureAllowed = false

    setTimeout @gestureCooled, 300

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
      @publishEvent 'changeNote',
        display: !!@isNoteVisible

  toggleNote: (broadcast = true) =>
    @updateNote(!@isNoteVisible, broadcast)