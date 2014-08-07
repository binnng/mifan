( (window, angular) ->

  ###
  angualr 指令
  手指轻碰一下就会触发事件
  ###

  'use strict'

  tap = angular.module 'binnng.tap', []

  WIN = window
  IsTouch = "ontouchend" of WIN
  
  # 如果不是移动设备，什么都不做
  return no if not IsTouch 

  LOC = location
  NA = WIN.navigator
  UA = NA.userAgent

  #IsAndroid = (/Android|HTC/i.test(UA) or /Linux/i.test(NA.platform + "")) 

  tap.directive "tap", ->

    link: (scope, element, attrs) ->

      fnName = attrs["tap"].replace "()", ""
      fn = scope[fnName]

      return no if not fn

      element.on "touchstart", (event) ->
        fn()
        event.stopPropagation() 

) window, angular
