define (require)->

  scanWorker_script = require 'text!./scanWorker.js'
  URL = window.URL || window.webkitURL

  console.log scanWorker_script

  wifiscan =
    scan: (privateIP)->
      scanIPList = @getIPListFromIP(privateIP)
      workerBlob = new Blob([scanWorker_script])
      workerURL = URL.createObjectURL(workerBlob)
      worker = new Worker(workerURL)
      worker.onmessage = (e)->

        console.log e
        data = e.data
        switch data.msgType
          when 'debug'
            console.log data[data.msgType]


      worker.postMessage(
        msgType: 'data'
        data: scanIPList
      )



    getIPListFromIP: (privateIP)->
      sp_ip = privateIP.split('.')
      sp_part1 = sp_ip.splice(0, 3)
      sp_part2 = sp_ip[3]
      scanIPList = []
      for i in [1..255]
        scanIPList.push(sp_part1.join('.')+".#{i}")

      scanIPList



