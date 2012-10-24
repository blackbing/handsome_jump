define (require)->

  scanWorker_script = require 'text!./scanWorker.js'
  URL = window.URL || window.webkitURL


  wifiscan =
    ips: {}
    portocol: 'http'
    port: 7777
    callback_fun:
      getStatusCallback: 'gsc'
      getInfoCallback: 'gic'
    scan: (privateIP)->
      scanIPList = @getIPListFromIP(privateIP)
      for ip in scanIPList
        if ip isnt privateIP
          @getInfo(ip).done((res)->
            console.log res
          )
        else
          console.log privateIP

    scanWorker: (privateIP)->
      scanIPList = @getIPListFromIP(privateIP)
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


      worker.postMessage(
        msgType: 'data'
        data: scanIPList
      )

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

    getIPListFromIP: (privateIP)->
      sp_ip = privateIP.split('.')
      sp_part1 = sp_ip.splice(0, 3)
      sp_part2 = sp_ip[3]
      scanIPList = []
      for i in [1..255]
        scanIPList.push(sp_part1.join('.')+".#{i}")

      scanIPList

  wifiscan

