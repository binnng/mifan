"use strict"

Mifan = angular.module "mifan", [
  "ngCookies"
  "ngResource"
  "ngSanitize"
  "ngRoute"
  "ngTouch"
  "binnng.touch.href"
  "binnng.scroller"
  "binnng.tap"
  "binnng.storage"
  "binnng.emoji"
]

Mifan.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(no).hashPrefix "!"

  $routeProvider
    .when("/",
      redirectTo: "/home"
    )
    .when("/home",
      templateUrl: "views/home/home.html"
      controller: "homeCtrl"
    )
    .when("/home/:type",
      templateUrl: "views/home/home.html"
      controller: "homeCtrl"
    )
    .when("/msg",
      templateUrl: "views/msg.html"
      controller: "msgCtrl"
    )
    .when("/me",
      templateUrl: "views/me/me.html"
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
    .when("/friend",
      templateUrl: "views/friend.html"
      controller: "friendCtrl"
    )
    .when("/square",
      templateUrl: "views/square/square.html"
      controller: "squareCtrl"
    )
    .otherwise
      templateUrl: "views/404.html"
      controller: "404Ctrl"

  no