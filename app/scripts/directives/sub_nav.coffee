# 二级导航
Mifan.directive "subNav", ->
	templateUrl: "views/template/sub-nav.html"
	replace: no
	transclude: yes
	restrict: "AE"
	scope:
		feedType: "=feedType"

	link: (scope, element, attrs)->

		#console.log scope

	compile: (element, attrs, transclude) ->
		pre: ->
		post: (scope, element, attrs, controller) ->

			ul = element[0].getElementsByTagName("ul")[0]
			items = ul.getElementsByTagName("li")

			length = items.length

			for ele in items
				ele.style.width = "#{100/length}%"
