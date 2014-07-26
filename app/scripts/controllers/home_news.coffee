
Mifan.controller "homeNews", ($scope) ->
	# ajax取到数据进行缓存，用户手动刷新
	$scope.content = "最新动态"
	console.log "最新动态"
	
	$scope.newsCollect = [
		{
			a: 1
		},
		{
			a: 2
		},
		{
			a: 2
		},
		{
			a: 2
		},
		{
			a: 2
		},
		{
			a: 2
		},
		{
			a: 2
		},
		{
			a: 2
		}
	]