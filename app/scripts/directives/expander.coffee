# 手风琴
# 展开一项，确保整个页面只有这一个展开

Mifan.directive "accordion", ->
	restrict: "EA"
	controller: ($scope) ->

		$scope.expanders = expanders = []

		this.gotOpened = (selectedExpander) ->
			angular.forEach expanders, (expander) ->
				expander.active = no if selectedExpander isnt expander

		this.addExpander = (expander) ->
			expanders.push expander


Mifan.directive "expander", ->
	restrict: "EA"
	require: "?accordion"
	transclude: yes
	scope: {}
	link: (scope, element, attrs, ctrl) ->

		console.log ctrl
		scope.active = no
		ctrl.addExpander scope

		scope.toggle = ->
			scope.active = not scope.active
			ctrl.gotOpened(scope)