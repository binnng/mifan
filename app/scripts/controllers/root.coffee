"use strict"

# 顶层的业务ctrl，控制整站
# 比如用户信息等

Mifan.controller "rootCtrl", ($scope, $cookieStore) ->

  UCNAME = $scope.UCNAME

  $scope.page = "home"

  $scope.user = JSON.parse($cookieStore.get(UCNAME) or "{}")

  $scope.supportNum = "1万"

  # 设置当前页面
  $scope.$on "pageChange", (e, msg) -> $scope.page = msg

  
  # 设置手机侧边栏菜单状态

  $scope.isMMenuOpen = no

  $scope.toggleMMenu = -> 
    $scope.isMMenuOpen = not $scope.isMMenuOpen

  $scope.logout = ->
    $scope.user = {}
    $cookieStore.remove UCNAME

