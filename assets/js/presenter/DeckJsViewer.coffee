#= require ./Slides

class @SlidesViewer extends Slides
  slidesProgressHook: (progress) ->
    pageNumber = parseInt(progress.to, 10)

    $.deck('go', pageNumber)

