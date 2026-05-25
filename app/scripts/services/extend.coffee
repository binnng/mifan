# 复制一个Object属性到另一个
# author: binnng

((window, angular) ->

	extend = (src, dist) ->
		src[name] = dist[name] for name of dist
		src

	(angular.module "binnng.extend", []).factory "$extend", ->
		extend


) window, angular
