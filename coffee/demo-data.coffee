define (require)->
  demoData =
    [
      {
        ip: 'x.x.x.x'
        url: 'https://graph.facebook.com/1012622593/picture?type=normal'
        name: 'James Wu'
      }
      {
        ip: 'x.x.x.x'
        url: 'https://graph.facebook.com/501012346/picture?type=normal'
        name: 'Chunghe Fang'
      }
      {
        ip: 'x.x.x.x'
        url: 'https://graph.facebook.com/1170084116/picture?type=normal'
        name: 'Chris Lee'
      }
      {
        ip: 'x.x.x.x'
        url: 'https://graph.facebook.com/587439623/picture?type=normal'
        name: 'Michael Lin'
      }
      {
        ip: 'x.x.x.x'
        url: 'https://graph.facebook.com/501753091/picture?type=normal'
        name: 'Pai-Cheng Tao'
      }

    ]


  showIdx = 0

  exports =
    _show: (circleView)->
      args = arguments
      d_data = demoData[showIdx]
      circleView.ipfound(d_data)
      showIdx++
      if showIdx < demoData.length

        delay = Math.random() * 10 * 50

        setTimeout(=>
          args.callee.apply(@, args)
        , delay)
    show: (circleView)->
      setTimeout(=>
        @_show(circleView)
      , 100)



