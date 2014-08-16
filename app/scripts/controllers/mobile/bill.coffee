Mifan.controller "mBillCtrl", ($scope) ->

	billListMap = 
		"love": 
			name: "喜欢"

		"comment": 
			name: "评论"
			fn: "toggleMDesign('comment')"
		
		"share": 
			name: "分享"

		"answer":
			name: "回答"
			fn: "toggleMDesign('answer')"
		

	$scope.billList = []

	$scope.$on "setBillList", (event, msg) ->
		$scope.billList = (billListMap[type] for type in msg)