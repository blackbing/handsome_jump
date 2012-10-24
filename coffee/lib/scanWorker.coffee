
_self = @
Req =
  port: 7777
  ips: {}
  callback_fun:
    getStatusCallback: 'gsc'
    getInfoCallback: 'gic'
  getStatus: (ip)->
    #url = "//#{ip}:#{@port}/getstatus"
    url = "http://#{ip}:#{@port}/getstatus?callback=#{@callback_fun.getStatusCallback}"
    #url = "http://api.twitter.com/1/followers/ids.json?cursor=-1&screen_name=ev&callback=gsc"
    log(url)
    _self.importScripts(url)

  getStatusCallback: (res)->
    log 'getStatusCallback'
    ip = res.ip
    @getInfo(ip)

  getInfo: (ip)->
    url = "http://#{ip}:#{@port}/getinfo?callback=#{@callback_fun.getInfoCallback}"
    _self.importScripts(url)

  getInfoCallback: (res)->
    log 'getInfoCallback'
    avatorUrl = res.url
    ip = res.ip

    if not @ips[ip]?
      log avatorUrl
      @ips[ip] = res
      @postMessage('ip-found', res)

  postMessage: (type, data)->
    postData =
      msgType: type
    postData[type] = data
    _self.postMessage(postData)

@onmessage = (e)=>
  data = e.data
  msgType = data.msgType
  switch msgType
    when 'data'
      data = data[data.msgType]
      #for ip in data
      #  Req.getStatus(ip)
      #FIXME: test ip
      ip = '114.45.253.178'
      Req.getStatus(ip)

      log(data)

  log('postMessage from worker ok')


log = (gg)=>
  @postMessage(
    msgType: 'debug'
    debug: gg
  )




@[Req.callback_fun.getStatusCallback] = ()->
  Req.getStatusCallback.apply(Req, arguments)
@[Req.callback_fun.getInfoCallback] = ()->
  Req.getInfoCallback.apply(Req, arguments)

