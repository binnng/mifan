# 格式化时间戳
# author: binnng

((window, angular) ->

  # 2014年10月19日
  time = (timestamp) ->

    date = new Date(timestamp - 0)

    year: date.getFullYear()
    month: date.getMonth() + 1
    day: date.getDate()
    hour: date.getHours()
    minute: date.getMinutes()
    second: date.getSeconds()

  # 刚刚，一天前，一周前。。。
  ago = (timestamp) ->

    # php可能传过来10位的时间错
    timestamp *= 1000 if String(timestamp).length is 10
    int = parseInt

    curTime = +new Date()
    timeDiff = curTime - timestamp
    agoTime = time(timestamp)
    if 1000 * 60 > timeDiff
      agoTime = "刚刚"
    else if 1000 * 60 <= timeDiff and 1000 * 60 * 60 > timeDiff
      agoTime = int(timeDiff / (1000 * 60)) + "分钟前"
    else if 1000 * 60 * 60 <= timeDiff and 1000 * 60 * 60 * 24 > timeDiff
      agoTime = int(timeDiff / (1000 * 60 * 60)) + "小时前"
    else if 1000 * 60 * 60 * 24 <= timeDiff and 1000 * 60 * 60 * 24 * 30 > timeDiff
      agoTime = int(timeDiff / (1000 * 60 * 60 * 24)) + "天前"
    else if 1000 * 60 * 60 * 24 * 30 <= timeDiff and 1000 * 60 * 60 * 24 * 30 * 12 > timeDiff
      agoTime = int(timeDiff / (1000 * 60 * 60 * 24 * 30)) + "月前"
    else
      agoTime = int(timeDiff / (1000 * 60 * 60 * 24 * 30 * 12)) + "年前"  if 1000 * 60 * 60 * 24 * 30 * 12 <= timeDiff
    
    agoTime

  Time = angular.module "binnng.time", []

  Time.factory "$time", ->
    time

  Time.filter "date", ->
    (timestamp) ->

      # 1970年8月25日
      {year, month, day} = time "#{timestamp}000"
      "#{year}年#{month}月#{day}日"

  Time.filter "ago", ->
    (timestamp) ->
      ago timestamp

) window, angular
