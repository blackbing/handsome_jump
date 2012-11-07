(function() {

  define(function(require) {
    var CircleView, circleView;
    CircleView = require('./circleView');
    circleView = new CircleView();
    $('body').append(circleView.$el);
    return circleView.render();
  });

}).call(this);
