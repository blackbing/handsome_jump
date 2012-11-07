(function() {

  define(function(require) {
    var demoData, exports, showIdx;
    demoData = [
      {
        ip: 'x.x.x.x',
        url: 'https://graph.facebook.com/1012622593/picture?type=normal',
        name: 'James Wu'
      }, {
        ip: 'x.x.x.x',
        url: 'https://graph.facebook.com/501012346/picture?type=normal',
        name: 'Chunghe Fang'
      }, {
        ip: 'x.x.x.x',
        url: 'https://graph.facebook.com/1170084116/picture?type=normal',
        name: 'Chris Lee'
      }, {
        ip: 'x.x.x.x',
        url: 'https://graph.facebook.com/587439623/picture?type=normal',
        name: 'Michael Lin'
      }, {
        ip: 'x.x.x.x',
        url: 'https://graph.facebook.com/501753091/picture?type=normal',
        name: 'Pai-Cheng Tao'
      }
    ];
    showIdx = 0;
    return exports = {
      _show: function(circleView) {
        var args, d_data, delay,
          _this = this;
        args = arguments;
        d_data = demoData[showIdx];
        circleView.ipfound(d_data);
        showIdx++;
        if (showIdx < demoData.length) {
          delay = Math.random() * 10 * 50;
          return setTimeout(function() {
            return args.callee.apply(_this, args);
          }, delay);
        }
      },
      show: function(circleView) {
        var _this = this;
        return setTimeout(function() {
          return _this._show(circleView);
        }, 100);
      }
    };
  });

}).call(this);
