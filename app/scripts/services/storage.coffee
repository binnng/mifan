((window, angular) ->

	# 对本地存贮对象的操作封装

	WIN = window

	Storage = angular.module "binnng.storage", []

	getStorage = ->
	  _localStorage = undefined
	  try
	    
	    # 在Android 4.0下，如果webview没有打开localStorage支持
	    # 在读取localStorage对象的时候会导致js运行出错，所以要放在try{}catch{}中 

	    _localStorage = WIN["localStorage"]
	  catch e
	    alert "localStorage is not supported"

	  getStorage = ->
	    WIN["localStorage"]

	  _localStorage

	storage = getStorage()

	Storage.factory "$storage", ->

		set: (key, value) ->
		  if storage
		    storage.setItem key, value

		get: (key) ->
			if storage
		    value = storage.getItem(key)

		# 清除本地存贮数据
		# key 可选，如果包含此参数，则只删除包含此前缀的项，否则清除全部缓存

		clear: (key) ->
		  if storage
		    if key
		      for key of storage
		        storage.removeItem key  if 0 is key.indexOf(key)
		    else
		      storage.clear()



) window, angular