"use strict"
angular.module("mifan", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
]).config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(false).hashPrefix "!"
  $routeProvider.when("/",
    templateUrl: "views/main.html"
    controller: "MainCtrl"
  ).otherwise
    templateUrl: "views/404.html"
    controller: "404Ctrl"

  no