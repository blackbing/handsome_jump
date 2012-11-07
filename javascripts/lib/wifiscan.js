(function() {

  define(function(require) {
    var URL, wifiscan;
    URL = window.URL || window.webkitURL;
    wifiscan = {
      mySelfIP: (function() {
        return window.location.hostname;
      })(),
      ips: {},
      portocol: 'http',
      port: 7777,
      callbacks: {},
      callback_fun: {
        getStatusCallback: '__gsc__',
        getInfoCallback: '__gic__'
      },
      scan: function(callbacks) {
        var mySelfIP,
          _this = this;
        mySelfIP = this.mySelfIP;
        this.getInfo(mySelfIP);
        this.callbacks.getInfoCallback = callbacks;
        return this.getServerList(mySelfIP).done(function(req) {
          var ip, scanIPList, _i, _len, _results;
          scanIPList = req;
          _results = [];
          for (_i = 0, _len = scanIPList.length; _i < _len; _i++) {
            ip = scanIPList[_i];
            _results.push(_this.getInfo(ip).done(function(res) {
              return console.log(res);
            }));
          }
          return _results;
        });
      },
      createScanWorker: function() {
        var scanWorker_script, worker, workerBlob, workerURL,
          _this = this;
        scanWorker_script = require('text!./scanWorker.js');
        workerBlob = new Blob([scanWorker_script]);
        workerURL = URL.createObjectURL(workerBlob);
        worker = new Worker(workerURL);
        worker.onmessage = function(e) {
          var data, msgData;
          console.log(e);
          data = e.data;
          msgData = data[data.msgType];
          switch (data.msgType) {
            case 'debug':
              return console.log(msgData);
            case 'ip-found':
              console.log('ip-found', msgData);
              return _this.getInfoCallback(msgData);
          }
        };
        setTimeout(function() {
          return worker.terminate();
        }, 500);
        return worker;
      },
      scanWorker: function(privateIP) {
        var scanIPList, worker;
        scanIPList = this.getIPListFromIP(privateIP);
        worker = this.createScanWorker();
        /*
              worker.postMessage(
                msgType: 'ip'
                ip: ip
              )
        */
        return worker.postMessage({
          msgType: 'scanIPList',
          scanIPList: scanIPList
        });
      },
      /*
          getInfoCallback: (res)->
            console.log 'getInfoCallback', res
            avatorUrl = res.url
            ip = res.ip
      
            ##FIXME: seperate with UI
            $avators = $('.connected li').not('.avator')
            random_idx = Math.floor(Math.random()*$avators.length)
            $avators.eq(random_idx)
            .hide()
            .addClass('avator img-circle')
            .css(
              backgroundImage: "url(#{avatorUrl})"
            ).fadeIn()
      */
      getServerList: function(ip) {
        var filter, url, _dfr;
        url = "//" + ip + ":" + this.port + "/getserverlist";
        _dfr = $.get(url);
        /*
              #FIXME: for testing
              _dfr = $.Deferred()
              testData = {
                0: "10.116.209.46"
                1: "10.116.209.81"
                2: "10.116.215.130"
              }
              #testing data end
        */
        filter = _dfr.pipe(function(res) {
          var arr, idx;
          console.log(res);
          res = $.parseJSON(res);
          console.log('filter', res);
          arr = [];
          for (idx in res) {
            ip = res[idx];
            arr.push(ip);
          }
          return arr;
        });
        return filter;
      },
      getIPListFromIP: function(privateIP) {
        var i, scanIPList, sp_ip, sp_part1, sp_part2, _dfr;
        _dfr = $.Deferred();
        sp_ip = privateIP.split('.');
        sp_part1 = sp_ip.splice(0, 3);
        sp_part2 = sp_ip[3];
        scanIPList = [];
        for (i = 0; i <= 254; i++) {
          scanIPList.push(sp_part1.join('.') + ("." + i));
        }
        _dfr.resolve(scanIPList);
        return _dfr;
      },
      getInfo: function(ip) {
        var _dfr,
          _this = this;
        _dfr = this.getStatus(ip);
        _dfr.pipe(function(res) {
          var url;
          url = "//" + ip + ":" + _this.port + "/getinfo?callback=" + _this.callback_fun.getInfoCallback;
          return $.getScript(url);
        });
        return _dfr;
      },
      getStatus: function(ip) {
        var url;
        url = "//" + ip + ":" + this.port + "/getstatus?callback=" + this.callback_fun.getStatusCallback;
        return $.getScript(url);
      },
      getStatusCallback: function(res) {
        return console.log('getStatusCallback', res);
      },
      getInfoCallback: function(res) {
        var avatorUrl, ip;
        console.log('getInfoCallback', res);
        avatorUrl = res.url;
        ip = res.ip;
        if (!(this.ips[ip] != null)) {
          if ((this.callbacks != null) && (this.callbacks.getInfoCallback != null)) {
            this.callbacks.getInfoCallback.fire(res);
          }
          return this.ips[ip] = res;
        }
      }
    };
    window[wifiscan.callback_fun.getStatusCallback] = function() {
      return wifiscan.getStatusCallback.apply(wifiscan, arguments);
    };
    window[wifiscan.callback_fun.getInfoCallback] = function() {
      return wifiscan.getInfoCallback.apply(wifiscan, arguments);
    };
    return wifiscan;
  });

}).call(this);
