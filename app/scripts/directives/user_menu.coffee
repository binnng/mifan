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