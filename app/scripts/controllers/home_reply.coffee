
Mifan.controller "homeReply", ($scope) ->
	$scope.content = "回应我的"
	console.log "回应我的"

	$scope.$emit "clearReplyRemind"