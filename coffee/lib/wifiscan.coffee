define (require)->

  URL = window.URL || window.webkitURL


  wifiscan =
    mySelfIP: do ->
      #FIXME: test ip
      return '10.116.220.175'

    ips: {}
    portocol: 'http'
    port: 7777
    callbacks: {}
    callback_fun:
      getStatusCallback: '__gsc__'
      getInfoCallback: '__gic__'
    scan: (callbacks)->
      mySelfIP = @mySelfIP
      @getInfo(mySelfIP)
      @callbacks.getInfoCallback = callbacks

      @getServerList(mySelfIP).done((req)=>
        scanIPList = req
        for ip in scanIPList
          @getInfo(ip).done((res)->
            console.log res
          )
      )

    createScanWorker: ()->
      scanWorker_script = require 'text!./scanWorker.js'
      workerBlob = new Blob([scanWorker_script])
      workerURL = URL.createObjectURL(workerBlob)
      worker = new Worker(workerURL)
      worker.onmessage = (e)=>
        console.log e
        data = e.data
        msgData = data[data.msgType]
        switch data.msgType
          when 'debug'
            console.log msgData
          when 'ip-found'
            console.log 'ip-found', msgData
            @getInfoCallback(msgData)
      setTimeout(=>
        worker.terminate()
      , 500)
      worker


    scanWorker: (privateIP)->
      scanIPList = @getIPListFromIP(privateIP)
      worker = @createScanWorker()
      ###
      worker.postMessage(
        msgType: 'ip'
        ip: ip
      )
      ###
      worker.postMessage(
        msgType: 'scanIPList'
        scanIPList: scanIPList
      )



    ###
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
    ###

    getServerList: (ip)->
      ###
      url = "//#{ip}:#{@port}/getserverlist"
      _dfr = $.get(url)
      ###
      #FIXME: for testing
      _dfr = $.Deferred()
      testData = {
        0: "10.116.220.12"
        1: "10.116.220.82"
      }
      #testing data end

      filter = _dfr.pipe((res)->
        console.log 'filter', res
        arr = []
        for idx of res
          ip = res[idx]
          arr.push ip
        arr
      )
      _dfr.resolve(testData)
      filter

    getIPListFromIP: (privateIP)->
      _dfr = $.Deferred()
      sp_ip = privateIP.split('.')
      sp_part1 = sp_ip.splice(0, 3)
      sp_part2 = sp_ip[3]
      scanIPList = []
      for i in [0..254]
        scanIPList.push(sp_part1.join('.')+".#{i}")

      _dfr.resolve(scanIPList)
      _dfr

    getInfo: (ip)->
      _dfr = @getStatus(ip)
      _dfr.pipe((res)=>
        url = "//#{ip}:#{@port}/getinfo?callback=#{@callback_fun.getInfoCallback}"
        $.getScript(url)
      )
      _dfr

    getStatus: (ip)->
      url = "//#{ip}:#{@port}/getstatus?callback=#{@callback_fun.getStatusCallback}"
      $.getScript(url)

    getStatusCallback: (res)->
      console.log 'getStatusCallback', res

    getInfoCallback: (res)->
      console.log 'getInfoCallback', res
      avatorUrl = res.url
      ip = res.ip

      if not @ips[ip]?
        if @callbacks? and @callbacks.getInfoCallback?
          @callbacks.getInfoCallback.fire(res)


        @ips[ip] = res



  window[wifiscan.callback_fun.getStatusCallback] = ()->
      wifiscan.getStatusCallback.apply(wifiscan, arguments)
  window[wifiscan.callback_fun.getInfoCallback] = ()->
      wifiscan.getInfoCallback.apply(wifiscan, arguments)
  wifiscan

