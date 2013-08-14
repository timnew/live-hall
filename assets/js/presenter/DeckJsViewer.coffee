#= require ./Slides

class @SlidesViewer extends Slides
  slidesProgressHook: (progress) ->
    pageNumber = parseInt(progress.to, 10)

    $.deck('go', pageNumber)

	onLeapGesture: (gesture) ->
		return if @gestureAllowed

		return if gesture.state != 'stop' or gesture.type != 'swipe'

		if gesture.direction[0] < 0 
			@onLeapSwipe 'next'
	  else
	  	@onLeapSwipe 'prev'

	onLeapSwipe: (direction) ->
		@gestureAccepted()
		
		$.deck direction