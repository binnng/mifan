# 二级导航
Mifan.directive "subNav", ->
  templateUrl: "views/template/sub-nav.html"
  replace: no
  transclude: yes
  restrict: "AE"
  scope: no

  # compile: (element, attrs, transclude) ->

  #   post: (scope, element, attrs) ->

  #     wrapEle = element[0]
  #     ul = wrapEle.getElementsByTagName("ul")[0]
  #     items = ul.getElementsByTagName("li")
  #     caret = wrapEle.getElementsByTagName("em")[0]

  #     length = items.length

  #     caret.style.left = "0px";

  #     for ele in items
  #       ele.style.width = "#{100/length}%"
