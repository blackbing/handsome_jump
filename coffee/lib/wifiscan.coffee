define (require)->

  URL = window.URL || window.webkitURL


  wifiscan =
    ips: {}
    portocol: 'http'
    port: 7777
    callback_fun:
      getStatusCallback: 'gsc'
      getInfoCallback: 'gic'
    scan: ()->
      #FIXME: test ip
      mySelfIP = '10.116.220.143'
      scanIPList = @getIPListFromIP(mySelfIP)
      @mySelfIP = mySelfIP
      for ip in scanIPList
        @getInfo(ip).done((res)->
          console.log res
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

    getIPListFromIP: (privateIP)->
      sp_ip = privateIP.split('.')
      sp_part1 = sp_ip.splice(0, 3)
      sp_part2 = sp_ip[3]
      scanIPList = []
      for i in [0..254]
        scanIPList.push(sp_part1.join('.')+".#{i}")

      scanIPList

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
        if ip is @mySelfIP
          $('.myself')
            .hide()
            .addClass('avator img-circle')
            .css(
              backgroundImage: "url(#{avatorUrl})"
            )
            .fadeIn()

        else
          ##FIXME: seperate with UI
          $avators = $('.connected li').not('.avator')
          random_idx = Math.floor(Math.random()*$avators.length)
          $avators.eq(random_idx)
            .hide()
            .addClass('avator img-circle')
            .css(
              backgroundImage: "url(#{avatorUrl})"
            )
            .fadeIn()

        @ips[ip] = res



  window[wifiscan.callback_fun.getStatusCallback] = ()->
      wifiscan.getStatusCallback.apply(wifiscan, arguments)
  window[wifiscan.callback_fun.getInfoCallback] = ()->
      wifiscan.getInfoCallback.apply(wifiscan, arguments)
  wifiscan

