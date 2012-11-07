(function() {

  define(function(require) {
    var CircleView, circleView_tpl, wifi;
    wifi = require('./lib/wifiscan');
    circleView_tpl = require('hbs!./circle');
    return CircleView = Backbone.View.extend({
      className: 'handsome-jump center',
      events: {
        'click #refresh': 'refreshIP'
      },
      refreshIP: function() {
        var callbacks, scanCallbacks,
          _this = this;
        callbacks = $.Callbacks();
        callbacks.add(function() {
          console.log('callbacks');
          return _this.ipfound.apply(_this, arguments);
        });
        return scanCallbacks = wifi.scan(callbacks);
      },
      ipfound: function(data) {
        var $avator, avatorPos, avatorUrl, ip, name;
        console.log('ipfound', data);
        ip = data.ip;
        name = data.name;
        avatorUrl = data.url;
        if (ip === wifi.mySelfIP) {
          return $('.myself').hide().addClass('avator img-circle').css({
            backgroundImage: "url(" + avatorUrl + ")"
          }).fadeIn();
        } else {
          /*
                  $avators = $('.connected li').not('.avator')
                  random_idx = Math.floor(Math.random()*$avators.length)
                  $avators.eq(random_idx)
                    .hide()
                    .addClass('avator img-circle')
                    .css(
                      backgroundImage: "url(#{avatorUrl})"
                    )
                    .fadeIn()
          */
          avatorPos = this.getBlankAvatorPos();
          $avator = $('<div />', {
            "class": 'avator img-circle'
          }).css({
            backgroundImage: "url(" + avatorUrl + ")",
            left: avatorPos.left,
            top: avatorPos.top
          }).append("<em>" + name + "</em>");
          return this.$('.connected').append($avator);
        }
      },
      getBlankAvatorPos: (function() {
        var avator, avatorPool, checkOverlap, getRandom, maxAmount, pool, radiusCount, radius_delta, radius_min, randomNumber, thetaMax;
        avator = {
          width: 100,
          height: 100,
          margin: 80
        };
        radius_min = 200;
        radius_delta = 150;
        maxAmount = 10;
        thetaMax = 360;
        radiusCount = 0;
        avatorPool = [];
        pool = [];
        checkOverlap = function(pos, pool) {
          var overlap, point, _i, _len;
          overlap = false;
          for (_i = 0, _len = pool.length; _i < _len; _i++) {
            point = pool[_i];
            if ((pos.x - (point.x - avator.width)) * (pos.x - (point.x + avator.width)) < 0 && (pos.y - (point.y - avator.height)) * (pos.y - (point.y + avator.height)) < 0) {
              overlap = true;
              break;
            }
          }
          console.log('checkOverlap!!!!');
          return overlap;
        };
        randomNumber = function(min, max) {
          if (max === null) {
            max = min;
            min = 0;
          }
          return min + (0 | Math.random() * (max - min + 1));
        };
        getRandom = function(canvas) {
          var avatorCountPerCircle, chkOverlap, circumference, myselfOffset, pos, r, radius_max, theta, thetaIndex, _i, _results;
          radius_max = Math.min(canvas.width / 2, canvas.height / 2, radius_min + radius_delta);
          if (avatorPool.length < 1) radiusCount++;
          r = 60 + radiusCount * (avator.width + avator.margin) + (avator.width / 2);
          circumference = 2 * r * Math.PI;
          avatorCountPerCircle = Math.floor(circumference / (avator.width + avator.margin));
          if (avatorPool.length < 1) {
            avatorPool = (function() {
              _results = [];
              for (var _i = 0; 0 <= avatorCountPerCircle ? _i <= avatorCountPerCircle : _i >= avatorCountPerCircle; 0 <= avatorCountPerCircle ? _i++ : _i--){ _results.push(_i); }
              return _results;
            }).apply(this);
          }
          thetaIndex = randomNumber(0, avatorPool.length - 1);
          theta = avatorPool[thetaIndex] / avatorCountPerCircle * thetaMax;
          myselfOffset = this.$('.myself').offset();
          pos = {
            x: (r * Math.sin(theta)) + myselfOffset.left,
            y: (r * Math.cos(theta)) + myselfOffset.top
          };
          chkOverlap = false;
          if (chkOverlap) {
            return arguments.callee.apply(this, arguments);
          } else {
            pool.push(pos);
            avatorPool.splice(thetaIndex, 1);
            return pos;
          }
        };
        return function() {
          var canvas, pos, randomPos;
          canvas = {
            width: this.$('.connected').width(),
            height: this.$('.connected').height()
          };
          randomPos = getRandom(canvas);
          return pos = {
            left: Math.floor(randomPos.x) + 10,
            top: Math.floor(randomPos.y) + 10
          };
        };
      })(),
      drawCircle: function() {
        var $c, $circle, $handsomeJump, $inner, innerWidth;
        $circle = this.$(".circle");
        $inner = $circle;
        $handsomeJump = this.$(".handsome-jump");
        innerWidth = $circle.width();
        $circle.css({
          height: innerWidth,
          width: innerWidth
        });
        while ($inner.width() > 300) {
          $c = $("<div class=\"circle-inner center\" />");
          $inner.append($c);
          $inner = $c;
        }
        return this.$('.circle-inner').last().append('<div class="myself center" />');
      },
      initialize: function() {
        return console.log('initialize');
      },
      render: function() {
        var tpl;
        console.log('render');
        tpl = circleView_tpl();
        this.$el.append(tpl);
        this.drawCircle();
        return this.refreshIP();
      },
      remove: function() {
        return console.log('remove');
      }
    });
  });

}).call(this);
