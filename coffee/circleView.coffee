define (require)->

  circleView_tpl = require 'hbs!./circle'

  CircleView = Backbone.View.extend
    className: 'handsome-jump center'

    resized: ()->

      console.log 'resized'

      $circle = @$(".circle")
      $inner = $circle
      $handsomeJump = @$(".handsome-jump")
      #innerWidth = $circle.prop('innerWidth')
      innerWidth = $('body').width()
      $circle.css
        height: innerWidth
        width: innerWidth

      console.log $circle, innerWidth
      while $inner.width() > 300
        console.log $inner.width()
        $c = $("<div class=\"circle-inner center\" />")
        $inner.append $c
        $inner = $c
      $circle.css
        #marginLeft: -($circle.width() - $handsomeJump.width()) / 2
        marginTop: -($circle.height() - $handsomeJump.height()) / 2 + 500

      while $(".connected>li").length < 40
        #$(".connected").append "<li class='avator img-circle'></li>"
        $(".connected").append "<li></li>"



    initialize: ()->
      console.log 'initialize'

    render: ()->
      console.log 'render'
      tpl = circleView_tpl()
      @$el.append tpl

      @resized()
    remove: ()->
      console.log 'remove'


