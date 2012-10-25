define (require)->

  CircleView = require './circleView'

  circleView = new CircleView()
  $('body').append(circleView.$el)
  circleView.render()
  #wifi.scanWorker('10.116.220.140')
