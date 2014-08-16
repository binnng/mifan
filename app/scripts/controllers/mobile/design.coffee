Mifan.controller "mDesginCtrl", ($scope, $timeout) ->

	DOC = $scope.DOC

	elMDesignTextarea = DOC["getElementById"] "m-design-input"

	titleMap = 
		"ask": "提出问题"
		"comment": "评论"
		"answer": "回答"

	# 设置展示界面类型
	# ask => 提问
	# comment => 评论
	#
	$scope.$on "setMDesignType", (detail, msg) ->
		$scope.viewType = msg
		$scope.title = titleMap[msg]

		$timeout ->
			elMDesignTextarea.focus()
		, 800

	# 取消内容发送的展示
	# 实际上后台还会继续网络请求发送
	$scope.$on "cancelMDesingSending", ->
		$scope.isSending = no
		$scope.mDesignContent = ""

	$scope.onSubmit = ->
		$scope.isSending = yes

