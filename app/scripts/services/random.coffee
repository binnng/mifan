# 取一个区间的随机数
# author: binnng

((window, angular) ->

	M = Math

	random = M.random

	random.in = (array) ->
		len = array.length

		min = array[0]
		max = array[len - 1]

		M.floor(min + random() * (max - min))

	(angular.module "binnng/random", []).factory "$random", ->
		random


) window, angular
