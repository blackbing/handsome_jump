define (require)->

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

    getInfo: (ip)->
      _dfr = @getStatus(ip)
      _dfr.pipe((res)=>
        url = "//#{ip}:#{@port}/getinfo?callback=#{@callback_fun.getInfoCallback}"
        $.getScript(url, (res)=>
          console.log 'getScripta', res
        )
      )

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
        ##FIXME: seperate with UI
        $avators = $('.connected li').not('.avator')
        random_idx = Math.floor(Math.random()*$avators.length)
        $avators.eq(random_idx)
        .hide()
        .addClass('avator img-circle')
        .css(
          backgroundImage: "url(#{avatorUrl})"
        ).fadeIn()

        @ips[ip] = res

    getIPListFromIP: (privateIP)->
      sp_ip = privateIP.split('.')
      sp_part1 = sp_ip.splice(0, 3)
      sp_part2 = sp_ip[3]
      scanIPList = []
      for i in [1..255]
        scanIPList.push(sp_part1.join('.')+".#{i}")

      scanIPList


  window[wifiscan.callback_fun.getStatusCallback] = ()->
    wifiscan.getStatusCallback.apply(wifiscan, arguments)
  window[wifiscan.callback_fun.getInfoCallback] = ()->
    wifiscan.getInfoCallback.apply(wifiscan, arguments)

  wifiscan

