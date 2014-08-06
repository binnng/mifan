( (window, angular) ->

  ###
  angualr 指令
  轮播器
  支持mobile and pc
  ###

  'use strict'

  DOC = document
  WIN = window
  UNDEFINED = undefined
  IsTouch = 'ontouchstart' of WIN
  UA = WIN.navigator.userAgent
  IsAndroid = (/Android|HTC/i.test(UA) or !!(WIN.navigator["platform"] + "").match(/Linux/i))

  START_EVENT = if IsTouch then 'touchstart' else 'mousedown'
  MOVE_EVENT = if IsTouch then 'touchmove' else  'mousemove'
  END_EVENT = if IsTouch then 'touchend' else 'mouseup'

  ngScorller = angular.module "binnng.scroller", []

  #ngScorller.directive "scroller", ->



) window, angular