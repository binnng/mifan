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
  "binnng.extend"
  "binnng/time"
  "binnng/debug"
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
    .when("/user/:id",
      templateUrl: "views/me/me.html"
      controller: "userCtrl"
    )
    .when("/q/:id",
      templateUrl: "views/ques/ques.html"
      controller: "quesDetailCtrl"
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
      templateUrl: "views/friend/friend.html"
      controller: "friendCtrl"
    )
    .when("/square",
      templateUrl: "views/square/square.html"
      controller: "squareCtrl"
    )
    .when("/search",
      templateUrl: "views/search.html"
      controller: "searchCtrl"
    )
    .otherwise
      templateUrl: "views/404.html"
      controller: "404Ctrl"

  no