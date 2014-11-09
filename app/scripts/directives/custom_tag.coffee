###
自定义标签
###

#加载更多
Mifan.directive "more", ->

	templateUrl: "views/template/more.html"
	replace: yes
	restrict: "AE"

#社交网络登录
Mifan.directive "snslogin", ->

	templateUrl: "views/template/sns-login.html"
	replace: yes
	restrict: "AE"

#用户相关菜单
Mifan.directive "usermenu", ->

	priority: 0
	templateUrl: "views/template/usermenu.html"
	replace: yes
	restrict: "E"
	scope: no

Mifan.directive "sending-btn", ->

	priority: 0
	templateUrl: "views/template/sending-btn.html"
	transclude: yes
	restrict: "E"
	scope: no

Mifan.directive "logintip", ->

	templateUrl: "views/template/logintip.html"
	replace: yes
	restrict: "AE"
	scope: no

Mifan.directive "errormsg", ->

	templateUrl: "views/template/error-msg.html"
	replace: yes
	restrict: "AE"
	scope: no

Mifan.directive "uiloading", ->

	templateUrl: "views/template/ui-loading.html"
	replace: yes
	restrict: "AE"
	scope: no

Mifan.directive "btnloading", ->

	template: "<em class=\"glyphicon glyphicon-refresh animated infinite\"></em>"
	replace: yes
	restrict: "AE"
	scope: no

#用户冒泡弹出菜单
# Mifan.directive "mbubble", ->

# 	priority: 0
# 	templateUrl: "views/mobile/bubble.html"
# 	replace: yes
# 	restrict: "E"

