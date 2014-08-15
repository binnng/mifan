
Mifan.controller "homeNews", ($scope, $timeout) ->
	# ajax取到数据进行缓存，用户手动刷新
	$scope.content = "最新动态"

	$scope.toggleMBubble = (index) ->
		$scope.newsCollect[index].bblActv = not $scope.newsCollect[index].bblActv

	$scope.newsCollect = [
		{
			ques:
				id: 1
				username: "依然大头"
				face: "http://mifan.us/cache/user/0/0/48/7dfecd76fb_48_48.png"
				text: "女朋友要过生日了，买个什么礼物呢？ 具体一些哈~~大谢！"

			ans: 
				id: 2
				username: "老婆婆"
				face: "http://mifan.us/cache/user/0/0/48/6c9e391e64_48_48.jpg"
				text: "买一个上市公司送她，让她做老板。"
			
			bblActv: no
			bblActvShow: no
		}
		{
			ques:
				id: 1
				username: "依然大头"
				face: "http://mifan.us/cache/user/0/0/48/7dfecd76fb_48_48.png"
				text: "女朋友要过生日了，买个什么礼物呢？ 具体一些哈~~大谢！"

			ans: 
				id: 2
				username: "老婆婆"
				face: "http://mifan.us/cache/user/0/0/48/6c9e391e64_48_48.jpg"
				text: "买一个上市公司送她，让她做老板。"
			
			bblActv: no
			bblActvShow: no
		}
		{
			ques:
				id: 1
				username: "依然大头"
				face: "http://mifan.us/cache/user/0/0/48/7dfecd76fb_48_48.png"
				text: "女朋友要过生日了，买个什么礼物呢？ 具体一些哈~~大谢！"

			ans: 
				id: 2
				username: "老婆婆"
				face: "http://mifan.us/cache/user/0/0/48/6c9e391e64_48_48.jpg"
				text: "买一个上市公司送她，让她做老板。"
			
			bblActv: no
			bblActvShow: no
		}
	]