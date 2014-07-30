#= require ./Slides

class @SlidesViewer extends Slides
  slidesProgressHook: (progress) ->
    Reveal.slide progress.h, progress.v, progress.f

  fragmentOffsetHook: (offset) ->
    if offset > 0
      Reveal.nextFragment()
    else
      Reveal.prevFragment()

  onLeapGesture: (gesture) ->
    console.log gesture.state, gesture.type, gesture.direction

    return if @gestureAllowed

    return if gesture.state != 'stop' or gesture.type != 'swipe'

    if Math.abs(gesture.direction[0]) > Math.abs(gesture.direction[1])
      # Horizontal
      @onLeapSwipe (if gesture.direction[0] < 0 then 'right' else 'left')
    else
      # Vertical
      @onLeapSwipe (if gesture.direction[1] < 0 then 'down' else 'up')

  onLeapSwipe: (direction) ->
    @gestureAccepted()
    console.log(direction)
    Reveal[direction]()