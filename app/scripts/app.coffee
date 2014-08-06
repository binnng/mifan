"use strict"

Mifan = angular.module "mifan", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
  "ngTouch"
  "ngTouchHref"
  "binnng.scroller"
]

Mifan.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(no).hashPrefix "!"

  $routeProvider
    .when("/",
      redirectTo: "/home"
    )
    .when("/home",
      templateUrl: "views/home.html"
      controller: "homeCtrl"
    )
    .when("/home/:type",
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
    .when("/welcome",
      templateUrl: "views/welcome.html"
      controller: "welcomeCtrl"
    )
    .when("/login",
      templateUrl: "views/login.html"
      controller: "loginCtrl"
    )
    .when("/register",
      templateUrl: "views/register.html"
      controller: "registerCtrl"
    )
    .otherwise
      templateUrl: "views/404.html"
      controller: "404Ctrl"

  no