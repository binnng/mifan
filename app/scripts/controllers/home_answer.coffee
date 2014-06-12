
angular.module("mifan").controller "homeAnswer", ($scope) ->
	$scope.content = "huidawode"
	console.log "huidawode"

	homeCtrlScope = angular.element('.home-page').scope()
	homeCtrlScope.remind.answerNum = 0