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
        console.log 'callbacks'
        @ipfound.apply(@, arguments)
      )
      scanCallbacks = wifi.scan(callbacks)


    ipfound: (data)->
      console.log('ipfound', data)
      ip = data.ip
      avatorUrl = data.url
      if ip is wifi.mySelfIP
        $('.myself')
          .hide()
          .addClass('avator img-circle')
          .css(
            backgroundImage: "url(#{avatorUrl})"
          )
          .fadeIn()

      else

        ###
        $avators = $('.connected li').not('.avator')
        random_idx = Math.floor(Math.random()*$avators.length)
        $avators.eq(random_idx)
          .hide()
          .addClass('avator img-circle')
          .css(
            backgroundImage: "url(#{avatorUrl})"
          )
          .fadeIn()
        ###
        avatorPos = @getBlankAvatorPos()
        $avator = $('<div />',
          class: 'avator img-circle'
        ).css(
          backgroundImage: "url(#{avatorUrl})"
          left: avatorPos.left
          top: avatorPos.top
        )
        @$('.connected').append($avator)

    getBlankAvatorPos: do ->
      avator =
        width: 100
        height: 100
      radius_min = 200
      getRandom = ()->
        radius_max = radius_min + 250
        r = (Math.random()*(radius_max-radius_min)) + radius_min
        theta = Math.random() * 360
        [r, theta]

      ->
        canvas =
          width: @$('.connected').width()
          height: @$('.connected').height()

        #radius_max = Math.min(canvas.width, canvas.height)/2
        ran = getRandom()
        r = ran[0]
        theta = ran[1]

        x = (r * Math.cos(theta)) + canvas.width/2
        y = r * Math.sin(theta) + canvas.height/2

        pos =
          left : x-(avator.width/2)
          top : y-(avator.height/2)

    drawCircle: ()->


      $circle = @$(".circle")
      $inner = $circle
      $handsomeJump = @$(".handsome-jump")
      innerWidth = $circle.width()
      $circle.css
        height: innerWidth
        width: innerWidth

      while $inner.width() > 300
        $c = $("<div class=\"circle-inner center\" />")
        $inner.append $c
        $inner = $c
      @$('.circle-inner').last().append('<div class="myself center" />')




      #while $(".connected>li").length < 40
      #  $(".connected").append "<li></li>"



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


