Mifan.controller "mDesginCtrl", ($scope, $timeout) ->

	DOC = $scope.DOC

	elMDesignTextarea = DOC["getElementById"] "m-design-input"

	# 设置展示界面类型
	# ask => 提问
	#
	$scope.$on "setMDesignType", (detail, msg) ->
		$scope.viewType = msg

		$timeout ->
			elMDesignTextarea.focus()
		, 400

	# 取消内容发送的展示
	# 实际上后台还会继续网络请求发送
	$scope.$on "cancelMDesingSending", ->
		$scope.isSending = no
		$scope.mDesignContent = ""

	$scope.onSubmit = ->
		$scope.isSending = yes

