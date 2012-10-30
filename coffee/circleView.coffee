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
      radius_delta = 150
      maxAmount = 10
      thetaMax = 360
      thetaPool = [] #(num*thetaMax/10 for num in [0..maxAmount])
      console.log thetaPool


      pool = []

      checkOverlap = (pos, pool)->
        overlap = false
        for point in pool
          if((pos.x-(point.x-avator.width))*(pos.x-(point.x+avator.width))<0 and (pos.y-(point.y-avator.height))*(pos.y-(point.y+avator.height))<0 )
            overlap = true
            break

        console.log 'checkOverlap!!!!'
        overlap

      randomNumber = (min, max)->
        if (max == null)
          max = min
          min = 0
        min + (0 | Math.random() * (max - min + 1))


      #canvas is the circle element, decide bounding of area
      getRandom = (canvas)->
        radius_max = Math.min(canvas.width/2, canvas.height/2, radius_min + radius_delta)
        r = (Math.random()*(radius_max-radius_min)) + radius_min
        #theta = Math.random() * 360

        if not thetaPool.length
          thetaPool = (num*thetaMax/10 for num in [0..maxAmount])

        thetaIndex = randomNumber(0, thetaPool.length-1)
        theta = thetaPool[thetaIndex]
        thetaPool.splice(thetaIndex, 1)
        pos =
          x : (r * Math.cos(theta)) + canvas.width/2
          y : r * Math.sin(theta) + canvas.height/2

        chkOverlap = checkOverlap(pos, pool)
        if chkOverlap
          arguments.callee.apply(@, arguments)
        else
          pool.push pos
          pos

      ->
        canvas =
          width: @$('.connected').width()
          height: @$('.connected').height()

        randomPos = getRandom(canvas)


        pos =
          left : Math.floor(randomPos.x-(avator.width/2))
          top : Math.floor(randomPos.y-(avator.height/2))

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


