define (require)->

  wifi = require './lib/wifiscan'
  circleView_tpl = require 'hbs!./circle'

  CircleView = Backbone.View.extend
    className: 'handsome-jump center'

    events:
      'click #refresh': 'refreshIP'

    refreshIP: ()->
      ##
      callbacks = $.Callbacks()
      callbacks.add(=>
        @ipfound(@, arguments)
      )
      scanCallbacks = wifi.scan(callbacks)


    ipfound: (data)->
        if ip is @mySelfIP
          $('.myself')
            .hide()
            .addClass('avator img-circle')
            .css(
              backgroundImage: "url(#{avatorUrl})"
            )
            .fadeIn()

        else

          $avators = $('.connected li').not('.avator')
          random_idx = Math.floor(Math.random()*$avators.length)
          $avators.eq(random_idx)
            .hide()
            .addClass('avator img-circle')
            .css(
              backgroundImage: "url(#{avatorUrl})"
            )
            .fadeIn()



    drawCircle: ()->

      console.log 'resized'

      $circle = @$(".circle")
      $inner = $circle
      $handsomeJump = @$(".handsome-jump")
      innerWidth = $circle.width()
      $circle.css
        height: innerWidth
        width: innerWidth

      console.log $circle, innerWidth
      while $inner.width() > 300
        console.log $inner.width()
        $c = $("<div class=\"circle-inner center\" />")
        $inner.append $c
        $inner = $c
      @$('.circle-inner').last().append('<div class="myself center" />')




      while $(".connected>li").length < 40
        $(".connected").append "<li></li>"



    initialize: ()->
      console.log 'initialize'

    render: ()->
      console.log 'render'
      tpl = circleView_tpl()
      @$el.append tpl

      @drawCircle()
      @refreshIP()
    remove: ()->
      console.log 'remove'


