
angular.module("mifan").controller "homeNews", ($scope) ->
	# ajax取到数据进行缓存，用户手动刷新
	$scope.content = "zuixindongtai"
	console.log "zuixindongtai"