Mifan.directive "more", ->

	template = [
		'<div class="load-more" ng-class="{loading: isLoading}" ng-click="loadingMore()">'
		'<span class="loading-tip">加载更多</span>'
		'<i class="ui-loading"></i>'
		'</div>'
	].join ""

	template: template
	replace: yes
	restrict: "E"