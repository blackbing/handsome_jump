
AJAX =
  get: (url)->
    try
      xhr = new XMLHttpRequest()
      xhr.open "GET", url, false
      xhr.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
      xhr.timeout = 500
      xhr.onreadystatechange = ->
        postMessage xhr.responseText  if xhr.status is 200  if xhr.readyState is 4

      xhr.send null
    catch e
      log "AJAX.get(#{url}) error"

Req =
  port: 8080
  getStatus: (ip)->
    url = "#{ip}:#{@port}/getstatus"
    log(url)
    AJAX.get(url, (res)->
      log(res)
    )

@onmessage = (e)=>
  data = e.data
  msgType = data.msgType
  switch msgType
    when 'data'
      data = data[data.msgType]
      for ip in data
        Req.getStatus(ip)

      log(data)

  log('postMessage from worker ok')


log = (gg)=>
  @postMessage(
    msgType: 'debug'
    debug: gg
  )





