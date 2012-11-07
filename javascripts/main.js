(function() {

  define(function(require) {
    var CircleView, circleView, demoData;
    CircleView = require('./circleView');
    circleView = new CircleView();
    $('body').append(circleView.$el);
    circleView.render();
    demoData = require('demo-data');
    return demoData.show(circleView);
  });

}).call(this);
