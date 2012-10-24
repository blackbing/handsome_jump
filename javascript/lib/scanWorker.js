// Generated by CoffeeScript 1.3.3
(function() {
  var Req, log, _self,
    _this = this;

  _self = this;

  Req = {
    port: 7777,
    ips: {},
    callback_fun: {
      getStatusCallback: 'gsc',
      getInfoCallback: 'gic'
    },
    getStatus: function(ip) {
      var url;
      url = "http://" + ip + ":" + this.port + "/getstatus?callback=" + this.callback_fun.getStatusCallback;
      log(url);
      return _self.importScripts(url);
    },
    getStatusCallback: function(res) {
      var ip;
      log('getStatusCallback');
      ip = res.ip;
      return this.getInfo(ip);
    },
    getInfo: function(ip) {
      var url;
      url = "http://" + ip + ":" + this.port + "/getinfo?callback=" + this.callback_fun.getInfoCallback;
      return _self.importScripts(url);
    },
    getInfoCallback: function(res) {
      var avatorUrl, ip;
      log('getInfoCallback');
      avatorUrl = res.url;
      ip = res.ip;
      if (!(this.ips[ip] != null)) {
        log(avatorUrl);
        this.ips[ip] = res;
        return this.postMessage('ip-found', res);
      }
    },
    postMessage: function(type, data) {
      var postData;
      postData = {
        msgType: type
      };
      postData[type] = data;
      return _self.postMessage(postData);
    }
  };

  this.onmessage = function(e) {
    var data, ip, msgType;
    data = e.data;
    msgType = data.msgType;
    switch (msgType) {
      case 'data':
        data = data[data.msgType];
        ip = '1.166.31.179';
        Req.getStatus(ip);
        log(data);
    }
    return log('postMessage from worker ok');
  };

  log = function(gg) {
    return _this.postMessage({
      msgType: 'debug',
      debug: gg
    });
  };

  this[Req.callback_fun.getStatusCallback] = function() {
    return Req.getStatusCallback.apply(Req, arguments);
  };

  this[Req.callback_fun.getInfoCallback] = function() {
    return Req.getInfoCallback.apply(Req, arguments);
  };

}).call(this);
