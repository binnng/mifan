
Mifan.controller "homeAnswer", ($scope) ->
	$scope.content = "回答我的"
	console.log "回答我的"

	$scope.$emit "clearAnswerRemind"
