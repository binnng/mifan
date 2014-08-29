DOC = document
WIN = window
LOC = location
BODY = DOC['body']

###
设备是否支持触摸事件
这里使用WIN.hasOwnProperty('ontouchend')在Android上会得到错误的结果
@type {boolean}
###
IsTouch = "ontouchend" of WIN

NA = WIN.navigator

UA = NA.userAgent

# HTC Flyer平板的UA字符串中不包含Android关键词
IsAndroid = (/Android|HTC/i.test(UA) or /Linux/i.test(NA.platform + "")) 
IsAndroidPad = IsAndroid and /Pad/i.test(UA)

IsIPad = not IsAndroid and /iPad/i.test(UA)

IsIPhone = not IsAndroid and /iPod|iPhone/i.test(UA)

IsIOS = IsIPad or IsIPhone

IsWindowsPhone = /Windows Phone/i.test(UA)

IsBlackBerry = /BB10|BlackBerry/i.test(UA)

IsIEMobile = /IEMobile/i.test(UA)
IsIE = !!DOC.all
IsWeixin = /MicroMessenger/i.test(UA)
IsChrome = !!WIN['chrome']

IsPhone = IsIPhone or (IsAndroid and not IsAndroidPad)

IsWebapp = !!NA["standalone"]

NG = WIN['angular']

IsDebug = LOC["port"] is "9000"