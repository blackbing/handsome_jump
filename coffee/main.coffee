define (require)->
  wifi = require './lib/wifiscan'

  CircleView = require './circleView'

  circleView = new CircleView()
  $('body').append(circleView.$el)
  circleView.render()
  #wifi.scan('10.116.220.140')
  wifi.scanWorker('10.116.220.140')
