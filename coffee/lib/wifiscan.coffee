define (require)->

  wifiscan =
    scan: (privateIP)->
      sp_ip = privateIP.split('.')
      sp_part1 = sp_ip.splice(0, 3)
      sp_part2 = sp_ip[3]
      scanIPList = []
      for i in [1..255]
        scanIPList.push(sp_part1.join('.')+".#{i}")

      console.log sp_ip
      console.log scanIPList
      scanIPList


