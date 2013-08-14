#= require ./Slides

class @SlidesViewer extends Slides
  slidesProgressHook: (progress) ->
    Reveal.slide progress.h, progress.v

  onLeapGesture: (gesture) ->
  	return if @gestureAllowed

    return if gesture.state != 'stop' or gesture.type != 'swipe'

    if Math.abs(gesture.direction[0]) > Math.abs(gesture.direction[1])
    	# Horizontal
    	@onLeapSwipe (if gesture.direction[0] < 0 then 'right' else 'left')    	
    else
    	# Vertical
    	@onLeapSwipe (if gesture.direction[1] < 0 then 'down' else 'top')   

  onLeapSwipe: (direction) ->
  	@gestureAccepted()

  	Reveal[direction]()