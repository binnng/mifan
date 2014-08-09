###
自定义标签
###

#加载更多
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

#社交网络登录
Mifan.directive "snslogin", ->

	template = [
		'<div class="sns-login">'
			'<a ng-href="http://mifan.us/index.php?app=pubs&ac=plugin&plugin=weibo&in=login" class="weibo"><i></i><span>新浪微博</span></a>'
			'<a ng-href="http://mifan.us/index.php?app=pubs&ac=plugin&plugin=qq&in=login" class="qq"><i></i><span>腾讯QQ</span></a>'
			'<a ng-href="http://mifan.us/index.php?app=pubs&ac=plugin&plugin=douban&in=login" class="douban"><i></i><span>豆瓣</span></a>'
		'</div>'
	].join ""

	template: template
	replace: yes
	restrict: "E"

#用户操作菜单
Mifan.directive "usermenu", ->

	template = [
		
			'<ul>'
		    '<li><a href="#!/"><span class="glyphicon glyphicon-cog"></span>设置</a></li>'
		    '<li><a href="#!/"><span class="glyphicon glyphicon-search"></span>找人</a></li>'
		    '<li><a href="#!/"><span class="glyphicon glyphicon-phone-alt"></span>反馈</a></li>'
		    '<li><a ng-click="support()"><span class="glyphicon glyphicon-thumbs-up"></span>32个赞</a></li>'
		    '<li><a ng-click="logout()"><span class="glyphicon glyphicon-off"></span>登出</a></li>'
		  '</ul>'

	].join ""

	template: template
	replace: yes
	restrict: "E"