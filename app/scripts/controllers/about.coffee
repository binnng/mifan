"use strict"

Mifan.controller "aboutCtrl", ($scope, $http) ->

  $scope.$on "$viewContentLoaded", -> $scope.$emit "pageChange", "about"

  about = 

  	init: ->

  		about.getAbout()

  	getAbout: ->

      api = "#{API.aboutsite}#{$scope.privacyParamDir}?infokey=about"
      api = API.aboutsite if IsDebug

      $http.get(api, cache: yes).success about.getAboutCb

  	getAboutCb: (data) ->

  		{ret, msg, result} = data

  		$scope.site = result

  about.init()
	  

  no