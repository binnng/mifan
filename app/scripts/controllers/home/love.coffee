
Mifan.controller "homeLove", ($scope) ->
	$scope.content = "喜欢我的"
	console.log "喜欢我的"

	$scope.$emit "clearLoveRemind"
