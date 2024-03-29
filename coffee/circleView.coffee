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

    preloadImg: (src)->
      _dfr = $.Deferred()
      _img = new Image()
      _img.onload = _dfr.resolve
      _img.onerror = _dfr.reject
      _img.src = src

      _dfr.promise()



    ipfound: (data)->
      console.log('ipfound', data)
      ip = data.ip
      name = data.name
      avatorUrl = data.url
      if ip is wifi.mySelfIP
        $myself = $('.myself')
        $myself
          .addClass('avator img-circle')
          .css(
            opacity: 0
            backgroundImage: "url(#{avatorUrl})"
          )
          .append("<em>#{name}</em>")

        @preloadImg(avatorUrl).done(=>
          $myself.animate(
            opacity: 1
          )
        )

      else

        avatorPos = @getBlankAvatorPos()
        $avator = $('<div />',
          class: 'avator img-circle'
        ).css(
          opacity: 0
          backgroundImage: "url(#{avatorUrl})"
          left: avatorPos.left
          top: avatorPos.top
        ).append("<em>#{name}</em>")
        @$('.connected').append($avator)
        @preloadImg(avatorUrl).done(=>
          $avator.animate(
            opacity: 1
          )
        )

    getBlankAvatorPos: do ->
      avator =
        width: 100
        height: 100
        margin: 80
      radius_min = 200
      radius_delta = 150
      maxAmount = 10
      thetaMax = 360

      radiusCount = 0
      avatorPool = []
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
        if avatorPool.length <1
          radiusCount++

        r = 60 + radiusCount*(avator.width+avator.margin) + (avator.width/2)
        circumference = 2*r*Math.PI
        avatorCountPerCircle = Math.floor(circumference /(avator.width+avator.margin))
        if avatorPool.length <1
          avatorPool = [0..avatorCountPerCircle]


        thetaIndex = randomNumber(0, avatorPool.length-1)
        theta = avatorPool[thetaIndex]/avatorCountPerCircle * thetaMax
        #theta = Math.random() * 360

        myselfOffset = @$('.myself').offset()
        pos =
          x : (r * Math.sin(theta)) + myselfOffset.left
          y : (r * Math.cos(theta)) + myselfOffset.top


        chkOverlap = false #checkOverlap(pos, pool)
        if chkOverlap
          arguments.callee.apply(@, arguments)
        else
          pool.push pos
          avatorPool.splice(thetaIndex, 1)
          pos

      ->
        canvas =
          width: @$('.connected').width()
          height: @$('.connected').height()

        randomPos = getRandom(canvas)


        pos =
          left : Math.floor(randomPos.x) + 10
          top : Math.floor(randomPos.y) + 10

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


