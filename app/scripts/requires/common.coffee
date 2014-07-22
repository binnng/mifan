"use strict"

Common =
	setCurrentPage: (currentPage) ->
		headScope = angular.element(".header").scope()
		headScope.currentPage = currentPage