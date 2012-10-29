define (require)->
  demoData =
    [
      {
        url: "https://graph.facebook.com/1627073717/picture?type=normal"
        ip: "10.116.217.50"
        name: "楊秉桓"
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
      {
        ip: 'x.x.x.x'
        url: 'https://graph.facebook.com/582724207/picture?type=normal'
        name: '高偉格'
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

        delay = Math.random() * 10 * 500

        setTimeout(=>
          args.callee.apply(@, args)
        , delay)
    show: (circleView)->
      setTimeout(=>
        @_show(circleView)
      , 1500)



