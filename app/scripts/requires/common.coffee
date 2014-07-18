"use strict"

Mifan = angular.module "mifan", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
]

Common = 
	init: ->

		Common.toggleNav()

	toggleNav: ->
		navItem = $ ".nav li"

		# navItem.on CLICK, ->
		  # $(@).siblings().removeClass(ACTIVE).end().addClass(ACTIVE)

	setCurrentPage: (currentPage) ->
		headScope = angular.element(".header").scope()
		headScope.currentPage = currentPage

Common.init()