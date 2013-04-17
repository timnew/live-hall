#= require ./Slides

class @SlidesViewer extends Slides
  slidesProgressHook: (progress) ->
    Reveal.slide progress.h, progress.v

