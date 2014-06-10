"use strict"
angular.module("mifan", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
]).config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(false).hashPrefix "!"
  $routeProvider
    .when("/",
      redirectTo: "/home"
    )
    .when("/home",
      templateUrl: "views/home.html"
      controller: "homeCtrl"
    )
    .when("/msg",
      templateUrl: "views/msg.html"
      controller: "msgCtrl"
    )
    .when("/me",
      templateUrl: "views/me.html"
      controller: "meCtrl"
    )
    .otherwise
      templateUrl: "views/404.html"
      controller: "404Ctrl"

  no