
Mifan.controller "homeReply", ($scope) ->
	$scope.content = "huifuwode"
	console.log "huifuwode"

	homeCtrlScope = angular.element('.home-page').scope()
	homeCtrlScope.remind.replyNum = 0