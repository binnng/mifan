# 保存常用DOM的全局变量（变量名可以被压缩） 

###
@type {Document}
###
DOC = document

###
@type {Window}
###
WIN = window

###
设备是否支持触摸事件
这里使用WIN.hasOwnProperty('ontouchend')在Android上会得到错误的结果
@type {boolean}
###
IsTouch = "ontouchend" of WIN

###
@type {string}
###
NA = WIN.navigator

###
@type {string}
###
UA = NA.userAgent

###
@type {boolean}
###
# HTC Flyer平板的UA字符串中不包含Android关键词
IsAndroid = (/Android|HTC/i.test(UA) or /Linux/i.test(NA.platform + "")) 

###
@type {boolean}
###
IsIPad = not IsAndroid and /iPad/i.test(UA)

###
@type {boolean}
###
IsIPhone = not IsAndroid and /iPod|iPhone/i.test(UA)

###
@type {boolean}
###
IsIOS = IsIPad or IsIPhone

###
@type {boolean}
###
IsWindowsPhone = /Windows Phone/i.test(UA)

###
@type {boolean}
###
IsBlackBerry = /BB10|BlackBerry/i.test(UA)

###
@type {boolean}
###
IsIEMobile = /IEMobile/i.test(UA)

###
@type {boolean}
###
IsIE = !!DOC.all

###
@type {boolean}
###
IsWeixin = /MicroMessenger/i.test(UA)

###
@type {boolean}
###
IsChrome = !!WIN['chrome']

CLICK = "click"
ACTIVE = "active"

NG = WIN['angular']