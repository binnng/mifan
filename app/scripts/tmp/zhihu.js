(function() {
  angular.module("auth", ["auth.interceptor"])
}).call(this),
function() {
  angular.module("auth.interceptor", []).factory("authErrorInterceptor", ["$q", "$rootScope",
    function(a, b) {
      return function(c) {
        return c.then(angular.identity, function(c) {
          return 401 === c.status && b.$broadcast("event:loginRequired"), a.reject(c)
        })
      }
    }
  ]).config(["$httpProvider",
    function(a) {
      return a.responseInterceptors.push("authErrorInterceptor")
    }
  ])
}.call(this),
function() {
  angular.module("auth").factory("activateDialog", ["dialog",
    function(a) {
      var b;
      return b = null, {
        open: function(c) {
          return this.close(), a.fromUrl("/scripts/auth/dialog-activate.html", {
            controller: "ActivateDialogCtrl",
            scope: c
          }).then(function(a) {
            return b = a, a.open()
          })
        },
        close: function() {
          return b ? b.close() : void 0
        }
      }
    }
  ]).controller("ActivateDialogCtrl", ["$scope", "activateDialog", "domainConfig", "dialog", "me",
    function(a, b, c, d, e) {
      return a.accountSettingsUrl = c.accountSettingsUrl, a.sent = !1, a.resend = function(c) {
        return c.preventDefault(), e.activate(function() {
          return a.sent = !0
        }, function(a) {
          return a.data.message ? (b.close(), d.message(a.data.message)) : void 0
        })
      }
    }
  ])
}.call(this),
function() {
  angular.module("auth").controller("LoginDialogCtrl", ["$scope", "$http", "$window", "$location", "domainConfig", "oauth",
    function(a, b, c, d, e, f) {
      return a.weiboLogin = function() {
        return f.register("sina")
      }, a.loginUrls = {
        mail: function() {
          return e.loginUrl()
        }
      }
    }
  ])
}.call(this),
function() {
  angular.module("auth").factory("loginDialog", ["dialog",
    function(a) {
      var b;
      return b = null, {
        open: function(c) {
          return this.close(), a.fromUrl("/scripts/auth/dialog.html", {
            controller: "LoginDialogCtrl",
            scope: c
          }).then(function(a) {
            return b = a, a.open()
          })
        },
        close: function() {
          return b ? b.close() : void 0
        }
      }
    }
  ])
}.call(this);
var app = angular.module("columnWebApp", ["auth", "blueimp.fileupload", "angularytics", "ngAnimate", "ngRoute", "ngTouch", "ngResource", "ngSanitize"]);
(function() {
  app.config(["fileUploadProvider",
    function(a) {
      return angular.extend(a.defaults, {
        disableImageResize: !1,
        maxFileSize: 5e6,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        send: function(a, b) {
          return delete b.headers["Content-Disposition"]
        },
        messages: {
          acceptFileTypes: "抱歉，目前只支持 jpg、png、gif 格式",
          maxFileSize: "抱歉，请上传大小为 5M 以下的图片文件"
        }
      })
    }
  ]), app.constant("siteName", "知乎专栏"), app.factory("domainConfig", ["$location",
    function(a) {
      var b;
      b = location.hostname.replace(/\w+\./, "");
      try {
        document.domain = b
      } catch (c) {}
      return {
        wwwDomain: "www." + b,
        columnDomain: "zhuanlan." + b,
        uploadDomain: "upload." + b,
        uploadUrl: "//upload." + b + "/upload",
        avatarUploadUrl: "//upload." + b + "/upload_avatar",
        qqOAuthUrl: "//www." + b + "/oauth/auth/qqconn",
        sinaOAuthUrl: "//www." + b + "/oauth/auth/sina",
        accountSettingsUrl: "//www." + b + "/settings/account",
        loginUrl: function() {
          return "http://www." + b + "/?next=" + decodeURIComponent(a.absUrl())
        }
      }
    }
  ]), app.run(function() {
    return angular.element(document.documentElement).removeClass("no-js")
  }), app.run(["mediator", "$window", "$rootScope",
    function(a, b, c) {
      return b.ZH = b.ZH || {}, b.ZH.cm = function(b, d) {
        return c.$apply(function() {
          return a.publish(b, d)
        })
      }
    }
  ]), app.run(["$location", "$http",
    function(a, b) {
      var c;
      return c = a.search().group_id, c ? (b.put("/api/notification/groups/" + c + "/read"), a.search({})) : void 0
    }
  ]), app.config(["AngularyticsProvider",
    function(a) {
      var b;
      return b = ["Google"], "localhost" === location.hostname && b.push("Console"), a.setEventHandlers(b)
    }
  ]).run(["Angularytics",
    function(a) {
      var b;
      return a.init(), b = angular.element(document), b.on("videobox:open", function() {
        return a.trackEvent("video", "click_videobox_open")
      }), b.on("lightbox:zoomin", function() {
        return a.trackEvent("image", "click_lightbox_zoomin")
      })
    }
  ]), app.run(["$rootScope",
    function(a) {
      var b, c;
      return c = /iPhone|iPad/.test(navigator.userAgent), (b = !c) ? (NProgress.configure({
        easing: "ease-out",
        minimum: .26,
        trickleRate: .15,
        trickleSpeed: 200,
        showSpinner: !1
      }), a.$on("$routeChangeStart", function() {
        return NProgress.start()
      }), a.$on("$routeChangeError", function() {
        return NProgress.done()
      }), a.$on("$routeChangeSuccess", function() {
        return NProgress.done()
      })) : void 0
    }
  ]), app.run(["$rootScope",
    function(a) {
      return a.$on("$routeChangeSuccess", function() {
        return "function" == typeof window.getSelection ? window.getSelection().removeAllRanges() : void 0
      })
    }
  ]), app.run(["$browser", "$http",
    function(a, b) {
      var c;
      return c = b.defaults, $.ajaxPrefilter(function(b) {
        var d, e;
        return void(b.processData && "get" !== (e = b.type) && "head" !== e && "options" !== e && (d = a.cookies()[c.xsrfCookieName], d && (b.headers = b.headers || {}, b.headers[c.xsrfHeaderName] = d)))
      })
    }
  ])
}).call(this),
function() {
  app.config(["$routeProvider", "$locationProvider",
    function(a, b) {
      var c, d, e, f, g;
      return b.html5Mode(!0), g = ["columnResolver",
        function(a) {
          return a()
        }
      ], f = ["postResolver",
        function(a) {
          return a()
        }
      ], c = ["authResolver",
        function(a) {
          return a()
        }
      ], d = ["$location", "$q",
        function(a, b) {
          var c, d;
          return c = b.defer(), d = angular.element(document.documentElement).hasClass("lt-ie9"), d ? (c.reject(), a.url("/ie")) : c.resolve()
        }
      ], e = ["$q", "columnResolver", "me", "$location",
        function(a, b, c, d) {
          var e;
          return e = a.defer(), b().then(function(a) {
            return a.creator.slug === c.slug ? e.resolve() : (e.reject("你没有权限访问这个页面"), d.url(a.url))
          }), e.promise
        }
      ], a.when("/", {
        pageTitle: "无需提问，也能回答",
        pageClass: "home",
        templateUrl: "/views/home.html",
        controller: "MainCtrl"
      }).when("/ie", {
        docTitle: "请升级您的浏览器",
        templateUrl: "/views/ie.html"
      }).when("/write", {
        pageTitle: "创作",
        pageClass: "page-write",
        templateUrl: "/views/post-write.html",
        controller: "PostWriteCtrl",
        resolve: {
          ieResolver: d,
          auth: ["authResolver", "$location", "$q",
            function(a, b, c) {
              var d;
              return d = c.defer(), a().then(function(a) {
                return a.columns.length ? d.resolve(a) : (d.reject(), b.url("/create"))
              }, d.reject), d.promise
            }
          ],
          draft: ["Draft",
            function(a) {
              return new a
            }
          ]
        }
      }).when("/create", {
        pageTitle: "创建专栏",
        docTitle: "创建",
        templateUrl: "/views/column-create.html",
        controller: "ColumnCreateCtrl",
        resolve: {
          ieResolver: d,
          betaStatus: ["domainConfig", "me",
            function(a, b) {
              return b.$promise.then(function() {
                return b.betaVerificationStatus
              }, function() {
                return location.href = a.loginUrl()
              })
            }
          ]
        }
      }).when("/drafts", {
        pageTitle: "我的草稿",
        pageClass: "",
        templateUrl: "/views/draft-list.html",
        controller: "DraftsCtrl",
        resolve: {
          auth: c
        }
      }).when("/drafts/:draftId", {
        pageTitle: "创作",
        pageClass: "page-write",
        templateUrl: "/views/post-write.html",
        controller: "PostWriteCtrl",
        resolve: {
          ieResolver: d,
          auth: c,
          draft: ["Draft", "$q", "$route", "$location", "renderServerError",
            function(a, b, c, d, e) {
              var f;
              return f = b.defer(), a.get(c.current.params).$promise.then(f.resolve, function(a) {
                switch (f.reject(a), a.status) {
                  case 404:
                    return d.url("/404");
                  case 500:
                    return e()
                }
              }), f.promise
            }
          ]
        }
      }).when("/404", {
        pageTitle: "没有找到该页面",
        templateUrl: "/views/404.html"
      }).when("/500", {
        pageTitle: "抱歉，程序出了些问题",
        templateUrl: "/views/500.html"
      }).when("/:columnSlug", {
        pageTitle: "",
        pageClass: "column-view",
        templateUrl: "/views/post-list.html",
        controller: "PostsCtrl",
        resolve: {
          column: g
        }
      }).when("/:columnSlug/settings", {
        pageTitle: "设置",
        templateUrl: "/views/column-settings.html",
        resolve: {
          ieResolver: d,
          auth: c,
          ownColumn: e,
          column: g
        }
      }).when("/:columnSlug/settings/authors", {
        pageTitle: "作者",
        templateUrl: "/views/column-settings-authors.html",
        resolve: {
          auth: c,
          ownColumn: e,
          column: g
        }
      }).when("/:columnSlug/followers", {
        pageTitle: "关注者",
        templateUrl: "/views/column-followers.html",
        controller: "ColumnFollowersCtrl",
        resolve: {
          column: g
        }
      }).when("/:columnSlug/:postSlug", {
        pageClass: "",
        templateUrl: "/views/post-view.html",
        controller: "PostViewCtrl",
        resolve: {
          resources: ["postResolver", "columnResolver",
            function(a, b) {
              var c;
              return c = {}, a().then(function(a) {
                return c.post = a, b().then(function(a) {
                  return c.column = a, c
                })
              })
            }
          ]
        }
      }).when("/:columnSlug/:postSlug/edit", {
        pageTitle: "编辑文章",
        pageClass: "page-write",
        templateUrl: "/views/post-write.html",
        controller: "PostWriteCtrl",
        resolve: {
          ieResolver: d,
          auth: c,
          column: g,
          draft: ["Draft", "$q", "$route", "$location", "renderServerError",
            function(a, b, c, d, e) {
              var f;
              return f = b.defer(), a.byPath(c.current.params).then(f.resolve, function(a) {
                switch (f.reject(a), a.status) {
                  case 404:
                    return d.url("/404");
                  case 500:
                    return e()
                }
              }), f.promise
            }
          ]
        }
      }).otherwise({
        redirectTo: "/"
      })
    }
  ])
}.call(this),
function() {
  app.factory("dialog", ["$timeout", "$rootScope", "$http", "$compile", "$controller", "$templateCache",
    function(a, b, c, d, e, f) {
      var g;
      return g = function(a, c) {
        var d, e;
        return null == c && (c = function() {}), e = a.scope, e && (delete a.scope, "function" == typeof e.$on && e.$on("$destroy", function() {
          return d.close()
        })), d = new zh.ui.Dialog(a), d.on("dialogselect", function(a) {
          return b.$apply(function() {
            return c.call(d, a.key)
          })
        }), d
      }, g.confirm = function(a, b, c, d) {
        var e, f, h;
        return null == d && (d = function() {}), e = {
          scope: a,
          cssClass: "confirm",
          buttons: {
            cancel: "取消",
            yes: "确认"
          }
        }, h = angular.extend({}, {
          title: b,
          content: c
        }, e), f = g(h, function(a) {
          return "yes" === a ? d() : void 0
        }), f.open()
      }, g.message = function(b, c) {
        var d, e, f;
        return null == c && (c = 1600), d = {
          title: "提示信息",
          cssClass: "message",
          buttons: {}
        }, f = angular.extend({}, {
          content: b
        }, d), e = g(f), a(function() {
          return e.close()
        }, c), e.open()
      }, g.fromUrl = function(a, b) {
        return c.get(a, {
          cache: f
        }).then(function(a) {
          var c, f, h, i, j;
          return h = angular.element(a.data), h.appendTo(document.body), f = g({
            scope: b.scope
          }), f.decorate(h[0]), f.on("afterhide", function() {
            return h.remove()
          }), j = (b.scope || h.scope()).$new(), d(h)(j), i = {
            $scope: j,
            element: h
          }, angular.extend(i, b.resolve), c = e(b.controller, i), h.data("$ngControllerController", c), f
        })
      }, g
    }
  ])
}.call(this),
function() {
  app.directive("uiConfirm", ["dialog",
    function(a) {
      return {
        restrict: "A",
        link: function(b, c, d) {
          return c.on("click", function() {
            var e;
            return e = d.confirmTitle || d.title || c.text() || "提示信息", a.confirm(b, e, d.confirmMessage, function() {
              return b.$eval(d.uiConfirm)
            })
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiDialog", ["dialog", "$parse",
    function(a, b) {
      return {
        restrict: "A",
        link: function(c, d, e) {
          var f, g;
          return g = {
            scope: c,
            autoDestroy: !1
          }, f = a(g), f.decorate(d[0]), f.on("afterhide", function() {
            return c.$apply(function() {
              return b(e.open).assign(c, !1)
            })
          }), c.$watch(function() {
            return d.height()
          }, function() {
            return f.isOpen() ? f.reposition() : void 0
          }), c.$watch(e.open, function(a) {
            return a ? f.open() : f.close()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.factory("reportService", ["dialog",
    function(a) {
      return function(b, c, d) {
        return a.fromUrl("/scripts/report/dialog-report.html", {
          controller: "ReportDialogCtrl",
          scope: d,
          resolve: {
            entry: b,
            type: c
          }
        }).then(function(a) {
          return a.open()
        })
      }
    }
  ])
}.call(this),
function() {
  app.controller("ReportDialogCtrl", ["$scope", "dialog", "$http", "entry", "type",
    function(a, b, c, d, e) {
      var f, g, h, i;
      return f = {
        0: "其他",
        501: "不构成问题",
        502: "广告等垃圾信息",
        503: "违法违规内容",
        504: "不宜公开讨论的政治内容",
        505: "不友善内容",
        506: "个人信息不合规范",
        507: "发布不友善内容",
        508: "发布广告等垃圾信息"
      }, g = {
        post: {
          title: "为什么举报这篇文章？",
          reasons: [505, 502, 503, 504, 0]
        },
        comment: {
          title: "为什么举报这个评论？",
          reasons: [505, 502, 503, 504, 0]
        }
      }, a.Reasons = f, a.ReasonsMap = g, i = "" + d.href + "/report", h = a.formData = {
        detail: "",
        reason: ""
      }, a.config = g[e], a.validate = function() {
        return this.errorShow = !0, this.reportForm.$valid
      }, a.post = function() {
        return c.post(i, h).success(function(a) {
          return b.message(a.message || "您的举报我们已经收到，处理完成后会私信告知处理结果")
        }).error(function(a) {
          return b.message(a.message || "举报失败，重新尝试一下？")
        })
      }, a.submit = function(b) {
        return a.validate() ? a.post(h) : (b.preventDefault(), b.stopPropagation())
      }
    }
  ])
}.call(this),
function() {
  app.factory("oauth", ["$window", "domainConfig",
    function(a, b) {
      return {
        register: function(c) {
          var d, e, f, g, h, i;
          return d = "/oauth/account_callback", i = {
            qq: "" + b.qqOAuthUrl + "?next=" + d,
            sina: "" + b.sinaOAuthUrl + "?next=" + d
          }, g = navigator.userAgent, e = /Mobile/.test(g) && /CriOS/.test(g), h = i[c], f = !e, f ? a.open(h, "oauth", "top=200,left=400,width=600,height=380,directories=no,menubar=no,toolbar=no") : location.href = h + "&from=" + encodeURIComponent(location.href)
        }
      }
    }
  ])
}.call(this),
function() {
  app.factory("me", ["$resource",
    function(a) {
      var b;
      return b = a("/api/me/:action", {}, {
        activate: {
          method: "PUT",
          params: {
            action: "activate"
          }
        }
      }), b.prototype.authed = function() {
        return !!this.name
      }, b.prototype.refresh = function() {
        return this.$get()
      }, b.prototype.activate = function() {
        return b.activate.apply(b, arguments)
      }, b.get()
    }
  ]), app.factory("requireLogin", ["$rootScope", "me",
    function(a, b) {
      return function(c) {
        return function() {
          return b.authed() ? c.apply(this, arguments) : a.$broadcast("event:loginRequired")
        }
      }
    }
  ]), app.factory("requireActivate", ["$rootScope", "me", "requireLogin",
    function(a, b, c) {
      return function(d) {
        return c(function() {
          return b.activated ? d.apply(this, arguments) : a.$broadcast("event:activateRequired")
        })
      }
    }
  ]), app.factory("requireNotMuted", ["$rootScope", "me", "requireLogin",
    function(a, b) {
      return function(c) {
        return function() {
          return b.muted ? a.$broadcast("event:notMutedRequired") : c.apply(this, arguments)
        }
      }
    }
  ])
}.call(this),
function() {
  app.factory("Post", ["$resource", "eagerHttp", "requireActivate",
    function(a, b, c) {
      var d;
      return d = a("/api/columns/:columnSlug/posts/:postSlug/:action", {
        postSlug: "@slug"
      }, {
        patch: {
          method: "PATCH"
        }
      }), d.prototype.remove = function(a, b) {
        return d.remove({
          columnSlug: this.column.slug,
          postSlug: this.slug
        }, a, b)
      }, d.prototype.setRating = function(a) {
        var b;
        return b = this.rating, b !== a ? (this.rating = a, "like" === a ? this.likesCount += 1 : "like" === b ? this.likesCount -= 1 : void 0) : void 0
      }, d.prototype.toggleRate = c(function(a) {
        var b, c = this;
        return b = this.rating, a = b === a ? "none" : a, this.setRating(a), this.rate(a).then(null, function() {
          return c.setRating(b)
        })
      }), d.prototype.toggleLike = function() {
        return this.toggleRate("like")
      }, d.prototype.toggleDislike = function() {
        return this.toggleRate("dislike")
      }, d.prototype.rate = b(function(a) {
        return {
          method: "PUT",
          url: "" + this.href + "/rating",
          data: {
            value: a
          }
        }
      }), d
    }
  ])
}.call(this),
function() {
  app.factory("Draft", ["$resource", "$http",
    function(a, b) {
      var c;
      return c = a("/api/drafts/:draftId/:action", {
        draftId: "@id"
      }, {
        create: {
          method: "POST"
        },
        patch: {
          method: "PATCH"
        },
        publish: {
          method: "PUT",
          params: {
            action: "publish"
          }
        }
      }), c.byPath = function(a) {
        return b.get("/api/columns/" + a.columnSlug + "/posts/" + a.postSlug + "/draft").then(function(a) {
          return new c(a.data)
        })
      }, c
    }
  ])
}.call(this),
function() {
  app.factory("Column", ["$resource", "eagerHttp",
    function(a, b) {
      var c;
      return c = a("/api/columns/:columnSlug/:action", {
        columnSlug: "@slug"
      }, {
        create: {
          method: "POST"
        },
        patch: {
          method: "PATCH"
        },
        follow: {
          method: "PUT",
          params: {
            action: "follow"
          }
        },
        unfollow: {
          method: "DELETE",
          params: {
            action: "follow"
          }
        },
        authors: {
          method: "GET",
          isArray: !0,
          params: {
            action: "authors"
          }
        }
      }), c.prototype.queryAuthors = function() {
        return c.authors({
          columnSlug: this.slug
        })
      }, c.prototype.setFollowing = function(a) {
        return this.following = a, this.followersCount += a ? 1 : -1
      }, c.prototype.toggleFollow = function() {
        var a, b = this;
        return a = !this.following, this.setFollowing(a), this.follow(a).then(null, function() {
          return b.setFollowing(!a)
        })
      }, c.prototype.follow = b(function(a) {
        return {
          method: a && "PUT" || "DELETE",
          url: "" + this.href + "/follow"
        }
      }), c
    }
  ])
}.call(this),
function() {
  app.factory("stacktraceService", function() {
    return {
      print: printStackTrace
    }
  }), app.provider("$exceptionHandler", {
    $get: ["errorLogService",
      function(a) {
        return a
      }
    ]
  }), app.factory("errorLogService", ["$log", "$window", "stacktraceService",
    function(a, b, c) {
      var d, e;
      return d = function(a, b) {
          var c;
          return c = null,
            function() {
              return clearTimeout(c), c = setTimeout(b.apply.bind(b, this, arguments), a)
            }
        }, e = d(300, function(a, b) {
          return $.ajax({
            method: "POST",
            url: "/api/client/errors",
            contentType: "application/json",
            data: angular.toJson(b)
          })
        }),
        function(d, f) {
          var g, h, i;
          a.error.apply(a, arguments);
          try {
            return g = d.toString(), i = c.print({
              e: d
            }), e("/api/client/errors", {
              userAgent: b.navigator.userAgent,
              errorUrl: b.location.href,
              errorMessage: g,
              stackTrace: i,
              cause: f || ""
            })
          } catch (j) {
            return h = j, a.warn("Error logging failed"), a.log(h)
          }
        }
    }
  ])
}.call(this),
function() {
  app.factory("Recommendation", ["$resource",
    function(a) {
      return a("/api/recommendations/:type")
    }
  ])
}.call(this),
function() {
  app.service("sharedData", ["$resource",
    function() {
      var a;
      return a = {}, {
        set: function(b, c) {
          return a[b] = c
        },
        get: function(b) {
          return a[b]
        },
        remove: function(b) {
          return delete a[b]
        }
      }
    }
  ])
}.call(this),
function() {
  app.service("globalAlert", ["$resource", "$timeout",
    function(a, b) {
      return {
        type: "info",
        message: "",
        set: function(a, c, d) {
          var e = this;
          return null == d && (d = 300), b(function() {
            return e.setSync(a, c)
          }, d)
        },
        setSync: function(a, b) {
          this.message = a, this.type = null != b ? b : "info"
        },
        clear: function() {
          return this.message = "", this.type = ""
        }
      }
    }
  ])
}.call(this),
function() {
  app.constant("parseLinkHeader", function() {
    var a, b;
    return b = /^<(.+)>$/, a = function(a) {
        var c, d, e, f;
        return f = a.split(";"), e = f.shift(), b.test(e) && (c = e.slice(1, -1)), d = {}, c && (d.href = c, f.forEach(function(a) {
          var b, c, e;
          return e = a.split("="), b = e[0], c = e[1], d[b] = c
        })), d
      },
      function(b) {
        var c;
        return b ? (c = b.split(","), c.reduce(function(b, c) {
          var d;
          return d = a(c), d.rel && d.href && (b[d.rel] = d), b
        }, {})) : {}
      }
  }())
}.call(this),
function() {
  app.service("linkHeaderSource", ["$http", "parseLinkHeader",
    function(a, b) {
      return {
        create: function(c, d) {
          var e;
          return null == d && (d = []), e = {
            url: c,
            error: !1,
            pending: !1,
            immediate: !0,
            completed: !1,
            onadd: function(a) {
              return d.push.apply(d, a)
            },
            onnext: function() {},
            fetch: function() {
              var c;
              return e.pending = !0, c = a.get(e.url), c["finally"](function() {
                return e.pending = !1
              }), c.success(function(a, c, d) {
                var f, g;
                return Array.isArray(a) && a.length && e.onadd(a), f = d("X-Result-Count"), f && (e.count = Number(f)), g = b(d("link")), g.next ? e.url = g.next.href : e.completed = !0, e.onnext()
              }).error(function() {
                return e.error = !0, e.completed = !0
              })
            }
          }
        }
      }
    }
  ])
}.call(this),
function() {
  app.service("snsShare", ["$window",
    function(a) {
      var b, c;
      return c = function(b) {
        return Object.keys(b).map(function(c) {
          return c + "=" + a.encodeURIComponent(b[c])
        }).join("&")
      }, b = {
        sina: {
          from: "分享自 @知乎 专栏",
          url: "http://service.weibo.com/share/share.php?",
          extra: {
            appkey: 3063806388
          }
        },
        qq: {
          from: "分享自 @izhihu 专栏",
          url: "http://v.t.qq.com/share/share.php?",
          extra: {
            appkey: 801128020
          }
        },
        douban: {
          from: "分享自知乎专栏",
          url: "http://www.douban.com/recommend/?"
        },
        twitter: {
          from: "分享自 @wenzhihu 专栏",
          url: "https://twitter.com/intent/tweet?"
        }
      }, {
        share: function(d, e, f, g) {
          var h, i;
          return null == g && (g = !0), h = b[d], h && f ? (f = angular.extend({}, f, h.extra), g && (f.title += e ? "（" + h.from + " · 作者：" + e + "）" : "（" + h.from + "）"), "twitter" === d && (f.text = f.title, delete f.title), i = c(f), a.open(h.url + i)) : void 0
        }
      }
    }
  ])
}.call(this),
function() {
  var a = [].slice;
  app.service("docTitle", ["$window", "siteName",
    function(b, c) {
      return {
        push: function() {
          var d;
          return d = 1 <= arguments.length ? a.call(arguments, 0) : [], b.document.title = d.concat(c).join(" - ")
        }
      }
    }
  ])
}.call(this),
function() {
  app.service("authResolver", ["$q", "$location", "domainConfig", "me",
    function(a, b, c, d) {
      var e;
      return e = function() {
        return location.href = c.loginUrl()
      }, this.resolve = function() {
        var b;
        return b = a.defer(), b.promise.then(null, e), d.$promise.then(function() {
          return d.beta ? b.resolve(d) : b.reject()
        }, b.reject), b.promise
      }
    }
  ])
}.call(this),
function() {
  app.service("columnResolver", ["$q", "$route", "$location", "$rootScope", "Column", "renderServerError",
    function(a, b, c, d, e, f) {
      return d.$on("$routeChangeStart", function(a, b) {
        return b.params.columnSlug ? void 0 : d.column = null
      }), this.resolve = function(g) {
        var h, i;
        return h = a.defer(), g = g || b.current.params.columnSlug, (null != (i = d.column) ? i.slug : void 0) === g ? h.resolve(d.column) : d.column = e.get({
          columnSlug: g
        }, h.resolve, function(a) {
          switch (h.reject(a), a.status) {
            case 404:
              return c.path("/404").replace();
            case 500:
              return f()
          }
        }), h.promise
      }
    }
  ])
}.call(this),
function() {
  app.service("postResolver", ["$q", "$route", "$location", "Post", "renderServerError",
    function(a, b, c, d, e) {
      return this.resolve = function() {
        var f, g;
        return f = a.defer(), g = b.current.params, d.get(g, function(a) {
          return a.column.slug === g.columnSlug ? f.resolve(a) : (f.reject(), c.url(a.url))
        }, function(a) {
          switch (f.reject(a), a.status) {
            case 404:
              return c.path("/404").replace();
            case 500:
              return e()
          }
        }), f.promise
      }
    }
  ])
}.call(this),
function() {
  app.factory("urlParser", function() {
    var a, b, c, d, e;
    return a = ["protocol", "host", "hostname", "port", "pathname", "search", "hash", "href"], b = /^(http:|https:|\/\/|\/)/, c = /^(http:|https:)/, e = function(d, e) {
      var f;
      return null == e && (e = !0), d && !(e && c || b).test(d) ? {} : (f = document.createElement("a"), f.href = d, a.reduce(function(a, b) {
        return a[b] = f[b], a
      }, {}))
    }, d = function(a) {
      var b, c;
      return b = e(a), "http:" === (c = b.protocol) || "https:" === c
    }, {
      parse: e,
      isUrl: d
    }
  })
}.call(this),
function() {
  app.factory("eagerHttp", ["$http", "$q",
    function(a, b) {
      return function(c) {
        var d;
        return d = null,
          function() {
            var e;
            return null != d && d.resolve(), d = b.defer(), e = c.apply(this, arguments), a(angular.extend(e, {
              timeout: d.promise
            }))["finally"](d.reject)
          }
      }
    }
  ])
}.call(this),
function() {
  var a = [].slice;
  app.factory("mediator", ["$rootScope",
    function(b) {
      var c;
      return c = function(c, d) {
        return b.$on(c, function() {
          var b, c;
          return b = arguments[0], c = 2 <= arguments.length ? a.call(arguments, 1) : [], d.apply(b, c)
        })
      }, {
        publish: function(a, c) {
          return b.$emit(a, c).returnValue
        },
        subscribe: function(a, b) {
          return Array.isArray(a) || (a = [a]), a.forEach(function(a) {
            return c(a, b)
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.factory("renderServerError", ["$compile", "$http", "$templateCache",
    function(a, b, c) {
      var d, e, f, g, h;
      return f = angular.element("[ng-view]"), g = f.scope(), e = "/views/500.html", d = function() {
        return f.children().each(function() {
          var a;
          return a = angular.element(this).scope().$destroy()
        }), f.empty()
      }, h = function(h) {
        return b.get(e, {
          cache: c
        }).success(function(b) {
          var c, e;
          return d(), e = g.$new(), e.message = h, c = angular.element(b), f.append(a(c)(e))
        }), !0
      }
    }
  ])
}.call(this),
function() {
  app.factory("preventUnload", ["$window",
    function(a) {
      return function(b, c, d) {
        return a.onbeforeunload = function() {
          return d() && c ? c : void 0
        }, b.$on("$destroy", function() {
          return a.onbeforeunload = null
        }), b.$on("$locationChangeStart", function(b) {
          return d() && !a.confirm("" + c + "，确定要离开此页吗？") ? b.preventDefault() : void 0
        })
      }
    }
  ])
}.call(this),
function() {
  app.filter("avatarUrl", ["$window",
    function(a) {
      var b, c, d;
      return c = {
          25: "s",
          34: "is",
          50: "xs",
          68: "im",
          75: "m",
          100: "l",
          200: "xl"
        }, b = function(a) {
          return function(b) {
            var d;
            return d = a.filter(function(a) {
              return a > b
            })[0], d ? c[d] : void 0
          }
        }(Object.keys(c)), d = {
          small: "s",
          medium: "xs",
          large: "l",
          "x-large": "xl"
        },
        function(e, f) {
          var g, h;
          return null == f && (f = "l"), e ? (angular.isObject(e) || (e = {
            template: e
          }), angular.isNumber(f) ? (f *= a.devicePixelRatio || 1, f > 200 && (f = 200), (h = c[f] || (h = b(f))) && (g = h)) : angular.isString(f) && (h = d[f]) && (g = h), e.template.replace("{id}", e.id || "").replace("{size}", g || f)) : void 0
        }
    }
  ])
}.call(this),
function() {
  app.filter("profileUrl", ["domainConfig",
    function(a) {
      return function(b) {
        return "" + a.wwwDomain + "/people/" + b
      }
    }
  ])
}.call(this),
function() {
  app.filter("linkDomain", ["urlParser",
    function(a) {
      return function(b) {
        var c;
        return c = a.parse(b).hostname, c ? c.replace(/^www\./, "") : b
      }
    }
  ])
}.call(this),
function() {
  app.filter("prettyDate", function() {
    return function(a) {
      var b;
      return a ? (b = moment(a).fromNow(), "几秒前" === b ? "刚刚" : b) : void 0
    }
  }), app.filter("formatDate", function() {
    return function(a, b) {
      return a ? moment(a).format(b || "llll") : void 0
    }
  })
}.call(this),
function() {
  app.filter("truncateHtml", function() {
    var a, b;
    return a = {
        maxlen: 200,
        ellipsis: "…",
        details: !1
      }, b = angular.element("<div>"),
      function(c, d) {
        var e, f, g, h, i, j, k, l, m;
        for (g = angular.extend({}, a, d || {}), f = 0, h = "", i = b.html(c).text(), m = i.split(""), k = 0, l = m.length; l > k && (e = m[k], f += e.charCodeAt(0) < 128 ? 1 : 2, h += e, !(f >= g.maxlen)); k++);
        return j = !1, h !== i && (j = !0, h += g.ellipsis), g.details ? {
          truncated: j,
          output: h
        } : h
      }
  })
}.call(this),
function() {
  app.directive("contenteditable", ["$timeout",
    function(a) {
      return {
        restrict: "A",
        require: "ngModel",
        link: function(b, c, d, e) {
          var f, g, h, i, j, k, l, m;
          return j = d.placeholder || "", i = "span.placeholder[contenteditable]", f = angular.element("<span>").addClass("placeholder").attr("contenteditable", !1).text(j), h = {
            el: f,
            visibleTags: "img, blockquote, pre, embed, video",
            empty: function() {
              var a;
              return a = c.text().length && c.text() !== j, !(a || c.find(this.visibleTags).length)
            },
            check: function() {
              return this.empty() ? this.show() : this.hide()
            },
            exists: function() {
              var a;
              return a = c.find(i), a.length ? (this.el = a.first(), a.slice(1).remove(), !0) : void 0
            },
            show: function() {
              return this.exists() || (this.el.text() || this.el.text(j), c.prepend(this.el)), this.selectStart()
            },
            hide: function() {
              return this.exists() ? this.el.remove() : void 0
            },
            selectStart: function() {
              var a, b;
              return document.activeElement === c[0] ? (a = this.el[0], b = a.previousSibling, b && 3 === b.nodeType && "" === b.nodeValue || (b = document.createTextNode(""), a.parentNode.insertBefore(b, a)), zh.editor.range.selectNodeStart(b)) : void 0
            }
          }, f.on("click", function() {
            return h.selectStart()
          }), c.on("click focus", function() {
            return h.check()
          }), c.on("input", function() {
            return h.hide()
          }), g = angular.element("<div>"), l = function() {
            return g.html(c.html()), g.find(i).remove(), e.$setViewValue(g.html())
          }, m = function(a) {
            var c;
            return "$apply" === (c = b.$root.$$phase) || "$digest" === c ? b.$eval(a) : b.$apply(a)
          }, k = "oninput" in c[0] ? "input" : "keyup", c.on("blur " + k + " change", function() {
            return m(l)
          }), e.$render = function() {
            return c.html(e.$viewValue)
          }, b.$watch(d.ngModel, function() {
            return h.check()
          }), a(function() {
            return l(), h.check()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("contentRequired", function() {
    return {
      restrict: "A",
      require: "ngModel",
      link: function(a, b, c, d) {
        var e, f, g, h, i, j;
        return g = c.placeholder || "", i = "img,embed", f = function() {
          return !!b.text().trim().length && b.text() !== g
        }, e = function() {
          return !!b.find(i).length
        }, h = function() {
          return !(f() || e())
        }, j = function(a) {
          return d.$setValidity("contentRequired", !h(a)), a
        }, d.$formatters.push(j), d.$parsers.push(j)
      }
    }
  })
}.call(this),
function() {
  app.directive("uniqueColumnSlug", ["Column", "me", "debounce",
    function(a, b, c) {
      return {
        restrict: "A",
        require: "ngModel",
        link: function(d, e, f, g) {
          var h, i, j;
          return h = "uniqueColumnSlug", i = c(350, function(c) {
            return a.get({
              columnSlug: c
            }, function(a) {
              return g.$setValidity(h, a.creator.slug === b.slug)
            }, function() {
              return g.$setValidity(h, !0)
            })
          }), j = function(a) {
            var b;
            return b = a && Object.keys(g.$error).filter(function(a) {
              return a !== h
            }).every(function(a) {
              return g.$error[a] === !1
            }), b && i(a), a
          }, g.$formatters.push(j), g.$parsers.push(j)
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiColumnsSelector", function() {
    return {
      restrict: "A",
      replace: !0,
      scope: {
        title: "@",
        mode: "@",
        show: "=",
        href: "=",
        onselect: "&"
      },
      templateUrl: "/views/columns-selector.html",
      controller: ["$scope", "$element", "$attrs", "$location", "$resource",
        function(a, b, c, d, e) {
          return a.$watch("show", function(b) {
            return b ? a.columns = e(a.href).query() : void 0
          }), a.close = function() {
            return a.show = !1
          }, a.select = function(b, d) {
            if (d) {
              if (d.metaKey) return;
              d.preventDefault(), d.stopPropagation()
            }
            return c.onselect && a.onselect({
              column: b
            }) !== !1 ? a.close() : void 0
          }, a.create = function() {
            return a.close(), d.path("/create")
          }
        }
      ]
    }
  })
}.call(this),
function() {
  app.directive("uiCtrlEnter", ["$parse", "$timeout",
    function(a) {
      return function(b, c, d) {
        var e, f;
        return e = a(d.uiCtrlEnter), f = function(a) {
          var b;
          return b = 13, a.keyCode === b && (a.ctrlKey || a.metaKey)
        }, c.on("keydown", function(a) {
          return f(a) ? (a.preventDefault(), b.$apply(function() {
            return e(b, {
              $event: a
            })
          })) : void 0
        })
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiEditor", ["globalAlert",
    function(a) {
      return {
        restrict: "A",
        link: function(b, c, d) {
          var e, f, g;
          return g = {}, g.onerror = function(c) {
            return b.$apply(function() {
              return a.setSync(c, "error")
            })
          }, "localhost" === location.hostname && (g.uploadUrl = "/upload", g.formatResponse = function(a) {
            return {
              src: a[0].url,
              width: 100,
              height: 200
            }
          }), f = {
            toolbarId: d.editorToolbar,
            FastUpload: g,
            OneClickUpload: g
          }, e = new zh.editor.Field(c.attr("id"), f), e.makeEditable(), e.on(["cvc", "delayedchange"], function() {
            return c.trigger("change")
          }), b.$on("$destroy", function() {
            return e.dispose()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiFocusMe", ["$timeout",
    function(a) {
      return function(b, c, d) {
        return b.$watch(d.uiFocusMe, function(b) {
          return b ? a(function() {
            return c[0].focus()
          }, 50) : void 0
        })
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiEvents", ["$parse", "$timeout",
    function(a, b) {
      return function(c, d, e) {
        var f;
        return f = c.$eval(e.uiEvents), angular.forEach(f, function(e, f) {
          return e = a(e), d.on(f, function(a) {
            var d;
            return d = a.type.indexOf("focus") > -1, d ? b(function() {
              return e(c, {
                $event: a
              })
            }) : c.$apply(function() {
              return e(c, {
                $event: a
              })
            })
          })
        })
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiPostComments", function() {
    return {
      restrict: "A",
      replace: !0,
      scope: {
        href: "=commentsHref",
        status: "=commentsStatus",
        expanded: "=commentsExpanded",
        postOwner: "=commentsPostOwner"
      },
      controller: "PostCommentsCtrl",
      templateUrl: "/views/post-comments.html"
    }
  })
}.call(this),
function() {
  app.directive("uiTextareaAutogrow", ["$timeout",
    function(a) {
      return {
        restrict: "A",
        require: "?ngModel",
        link: function(b, c, d, e) {
          var f, g;
          return g = !1, f = function() {
            return g || c.val() ? c.height(1).height(c.prop("scrollHeight")) : g = !0
          }, e ? b.$watch(d.ngModel, f) : c.bind("input change paste propertychange", function() {
            return a(f)
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiTime", function() {
    return {
      restrict: "A",
      replace: !0,
      scope: {
        datetime: "@"
      },
      template: '<time title="{{datetime | formatDate}}">{{datetime | prettyDate}}</time>'
    }
  })
}.call(this),
function() {
  app.directive("uiAlertbar", ["$timeout", "$window",
    function(a, b) {
      return {
        restrict: "A",
        replace: !0,
        scope: {
          alert: "="
        },
        template: '<div class="ui-alertbar {{alert.type}}" ng-show="alert.message">\n  <div class="receptacle">\n    <i class="icon icon-alertbar-{{alert.type}}"></i>\n    {{alert.message}}\n  </div>\n</div>',
        link: function(c) {
          var d;
          return d = angular.element(b), c.$watch("alert.message", function(b) {
            return b ? (a(function() {
              return d.scroll()
            }), a(function() {
              return c.alert.message = ""
            }, 3e3)) : void 0
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiSticky", ["$window",
    function(a) {
      return {
        restrict: "A",
        link: function(b, c, d) {
          var e, f, g, h, i, j, k;
          return k = angular.element(a), e = d.align || "bottom", j = angular.element(d.target), i = d.stickyClass || "sticky", f = {
            top: function() {
              return k.scrollTop() + k.height() < j.offset().top
            },
            bottom: function() {
              return k.scrollTop() > j.offset().top + j.height()
            }
          }, g = function() {
            return c.is(":visible") && j.is(":visible")
          }, h = function() {
            var a;
            return g() ? (a = f[e](), c.toggleClass(i, a), c.toggleClass("un" + i, !a)) : void 0
          }, k.scroll(h), b.$on("$destroy", function() {
            return k.unbind("scroll", h)
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiLightbox", ["$parse", "$window", "$compile", "$rootScope",
    function(a, b, c) {
      var d, e, f, g, h, i, j, k, l, m, n, o;
      return d = 27, e = '<div\n ng-show="zoomed"\n ng-animate="{show: \'in\', hide: \'out\'}"\n class="lightbox-overlay"></div>', k = function() {
        var a, b, c;
        return a = "width:50px;height:50px;overflow:scroll;position:absolute;top:-999em;", b = angular.element('<div style="' + a + '">'), b.appendTo(document.body), c = b[0].offsetWidth - b[0].clientWidth, b.remove(), c
      }(), l = "img.zh-lightbox-thumb", m = "data-thumb", j = "data-original", n = "data-rawwidth", f = "data-rawheight", i = "zoomed", g = "lightbox-zoomin", h = "lightbox-zoomin-active", k > 0 && (o = "html." + g + " body {padding-right: " + k + "px;}", angular.element("<style>").text(o).appendTo(document.body)), {
        restrict: "A",
        link: function(a, k) {
          var m, o, p, q, r, s, t, u, v, w, x, y, z, A, B, C, D;
          return B = angular.element(b), o = angular.element(document.body), s = angular.element(document.documentElement), w = c(e)(a), w.appendTo(k), a.zoomed = !1, t = null, x = function(a) {
            return {
              x: a.left + a.width / 2,
              y: a.top + a.height / 2
            }
          }, y = function(a, b) {
            return {
              x: b.x - a.x,
              y: b.y - a.y
            }
          }, A = function() {
            return {
              left: 0,
              top: 0,
              width: B.width(),
              height: B.height()
            }
          }, q = function(a) {
            return y(x(a), x(A()))
          }, p = function(a, b) {
            var c, d, e, f, g, h;
            return e = 20, f = A(), f = {
              width: f.width - e,
              height: f.height - e
            }, g = f.width / f.height, h = b.width, c = b.height, d = h / c, f.width > h && f.height > c || (g > d ? (c = f.height, h = c * d) : (h = f.width, c = h / d)), h / a.width
          }, u = function(b) {
            return b.keyCode === d ? a.$apply(D) : void 0
          }, v = function() {
            return a.$apply(D)
          }, m = function() {
            return o.on("keydown", u), w.on("click", v)
          }, r = function() {
            return o.off("keydown", u), w.off("click", v)
          }, z = function() {
            var a, b, c, d, e;
            return c = t[0].getBoundingClientRect(), a = q(c), b = {
              width: c.width,
              height: c.height
            }, e = {
              width: +t.attr(n),
              height: +t.attr(f)
            }, d = p(b, e), t.css({
              translate: [a.x, a.y],
              scale: d
            })
          }, C = function() {
            return t.attr("src", t.attr(j)), t.addClass(i), s.addClass(g), z(), a.zoomed = !0, m(), t.trigger("lightbox:zoomin")
          }, D = function() {
            return t.removeAttr("style"), s.addClass(h), t.one("transitionend", function() {
              return t.removeClass(i), s.removeClass(g), s.removeClass(h), t = null
            }), a.zoomed = !1, r(), t.trigger("lightbox:zoomout")
          }, k.on("click", l, function() {
            return t = angular.element(this), a.$apply(function() {
              return a.zoomed ? D() : C()
            })
          }), a.$on("$destroy", function() {
            return a.zoomed && D(), w.remove()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiMenuButton", ["$timeout", "$parse",
    function(a, b) {
      var c;
      return c = function(c, d, e) {
        var f, g, h, i, j, k, l, m, n, o, p;
        return l = b(e.onbeforeopen), n = "ontouchstart" in document, p = Number(e.toggleDelay) || 150, n && (p = 0), c.$on("$locationChangeStart", function() {
          return m(!1)
        }), i = angular.element(document), j = function() {
          return c.$apply(function() {
            return m(!1)
          })
        }, m = function(a) {
          return c.open = a, a && l(c), n ? i[a && "on" || "off"]("click", j) : void 0
        }, k = d.find("menu"), k.on("click", function() {
          return a(function() {
            return h(!1)
          })
        }), g = d.find(".menu-button"), g.on("keydown", function(a) {
          var b, d, e;
          return d = 32, b = 13, (e = a.keyCode) === d || e === b ? (a.preventDefault(), h(!c.open)) : void 0
        }), k.add(g).on("focusout", function(b) {
          var c;
          return c = function(a) {
            return k[0].contains(a) ? void 0 : h(!1)
          }, b.relatedTarget ? c(b.relatedTarget) : a(function() {
            return c(document.activeElement)
          })
        }), o = null, h = function(b) {
          return a.cancel(o), o = a(function() {
            return m(b)
          }, p)
        }, n ? g.on("click", function() {
          return h(!c.open)
        }) : g.add(k).on("mouseenter mouseleave", function(a) {
          return h("mouseenter" === a.type)
        }), f = function() {
          return k.children(".menu-item").andSelf().attr("tabindex", 0)
        }, c.$watch(function() {
          return k.children().length
        }, function() {
          return f()
        })
      }, {
        restrict: "A",
        scope: !0,
        replace: !0,
        transclude: !0,
        template: "<div ng-transclude class=\"ui-menu-button\"\n  ng-class=\"{ true: 'open', false: 'close' }[open]\"></div>",
        controller: ["$scope", "$element", "$attrs", "$timeout",
          function(a, b, d, e) {
            return e(function() {
              return c(a, b, d), b.addClass(d["class"])
            })
          }
        ]
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiCleanPaste", ["$timeout",
    function() {
      return {
        restrict: "A",
        link: function(a, b) {
          var c, d;
          return d = {
            reservedClasses: ["member_mention"]
          }, c = new zh.ui.HtmlCleaner(b, d)
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiMention", ["domainConfig", "$filter",
    function(a, b) {
      return {
        restrict: "A",
        link: function(c, d) {
          var e, f, g, h;
          return e = b("avatarUrl"), g = {
            renderLink: function(b) {
              return '<a href="http://' + a.wwwDomain + "/people/" + b.slug + '" data-hash="' + b.hash + '">@' + b.name + "</a>"
            }
          }, h = {
            method: "GET",
            source: "/api/autocomplete/users",
            renderRow: function(a) {
              return '<img class="avatar" src="' + e(a.avatar, 25) + '"><span class="name">' + a.name + "</span>"
            }
          }, f = new zh.ui.MentionInput(d[0], g, h), c.$on("$destroy", function() {
            return f.destroy()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiScraper", function() {
    return {
      restrict: "A",
      link: function(a, b, c) {
        var d, e;
        return d = a.$eval(c.scraperOptions), e = new zh.ui.Scraper(b[0], d), a.$on("$destroy", function() {
          return e.destroy()
        })
      }
    }
  })
}.call(this),
function() {
  app.directive("uiTitleScraper", ["$timeout", "$http", "$parse", "urlParser",
    function(a, b, c, d) {
      return {
        restrict: "A",
        require: "ngModel",
        link: function(e, f, g, h) {
          var i, j, k, l, m, n, o, p, q, r;
          return m = c(g.onscrapesuccess), l = c(g.onscrapestart), k = c(g.onscrapeend), j = f[0], n = !1, o = function(a) {
            return b.get("/api/scraper", {
              cache: !0,
              params: {
                url: a
              }
            })
          }, r = function(a) {
            return m(e, {
              link: a
            }), h.$setViewValue(a.title), h.$render(), f.trigger("change")
          }, q = function() {
            return n = !0, l(e)
          }, p = function() {
            return n = !1, k(e)
          }, i = function() {
            var a;
            return n ? void 0 : (a = j.value.trim(), a && d.isUrl(a) ? (q(), o(a).then(function(a) {
              return "link" === a.data.type && r(a.data), p()
            }, function() {
              return p()
            })) : void 0)
          }, f.on("paste", function() {
            return a(i)
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.provider("infinite", function() {
    return {
      defaults: {
        distance: 400,
        spinner: "<div ui-spinner></div>"
      },
      $get: function() {
        return this.defaults
      }
    }
  }), app.directive("uiInfinite", ["$window", "$compile", "$timeout", "infinite", "debounce",
    function(a, b, c, d, e) {
      return {
        restrict: "A",
        link: function(f, g, h) {
          var i, j, k, l, m, n, o, p, q, r, s, t, u;
          return t = "ui-infinite", l = "immediate", q = f.$eval(h.source), s = f.$eval(h.spinner) || d.spinner, i = f.$eval(h.distance) || d.distance, u = angular.element(a), p = u, g.addClass(t), r = b(s)(f).appendTo(g), f.$watch(function() {
            return q.completed
          }, function(a) {
            return a ? j() : void 0
          }), m = function() {
            return q.pending ? void 0 : q.fetch().then(function(a) {
              return !a.data || Array.isArray(a.data) && !a.data.length ? j() : c(k, 100), a
            })
          }, j = function() {
            return r.remove(), u.off("resize", k), p.off("scroll", k)
          }, n = function() {
            var a, b;
            return b = r[0].parentNode && "none" !== r.css("display"), a = r[0].getBoundingClientRect().top, b && a > 0 && a - u.height() <= i
          }, o = function(a, b) {
            var c;
            return c = a.$root.$$phase, "$apply" === c || "$digest" === c ? a.$eval(b) : a.$apply(b)
          }, k = e(200, function() {
            return q.pending ? void 0 : o(f, function() {
              return n() ? m() : void 0
            })
          }), q.immediate && (g.addClass(l), m().then(function() {
            return g.removeClass(l)
          })), u.on("resize", k), p.on("scroll", k), f.$on("$destroy", function() {
            return j()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiTabs", function() {
    return {
      restrict: "A",
      scope: {
        selectedIndex: "@"
      },
      replace: !0,
      transclude: !0,
      controller: "TabsCtrl",
      template: '<div class="ui-tabs">\n  <div class="tabs-nav clearfix">\n    <a href="#" class="tabs-anchor" ng-click="select(tab, $event)" ng-class="{ active: activeIndex == $index }" ng-repeat="tab in tabs">{{tab.title}}</a>\n  </div>\n  <div class="tabs-content" ng-transclude></div>\n</div>'
    }
  }), app.controller("TabsCtrl", ["$scope", "$location",
    function(a) {
      var b, c, d = this;
      return c = a.tabs = [], b = function(b) {
        return d.activeIndex = a.activeIndex = b
      }, this.addTab = function(a, b) {
        return c.push({
          title: a,
          anchor: b
        })
      }, this.select = a.select = function(a, d) {
        return null != d && d.preventDefault(), b(c.indexOf(a))
      }, b(Number(a.selectedIndex) || 0)
    }
  ]), app.directive("uiTabPane", function() {
    return {
      require: "^uiTabs",
      restrict: "A",
      scope: {
        title: "@tabTitle",
        anchor: "@tabAnchor"
      },
      replace: !0,
      transclude: !0,
      template: '<div class="tabs-pane" ng-transclude ng-show="active()"></div>',
      link: function(a, b, c, d) {
        return a.index = b.index(), a.active = function() {
          return d.activeIndex === a.index
        }, d.addTab(a.title, a.anchor)
      }
    }
  })
}.call(this),
function() {
  app.directive("uiTagInput", function() {
    var a;
    return a = {
      minTags: 1,
      maxTags: 1 / 0,
      placeholder: "",
      suggestUrl: "/api/autocomplete/topics"
    }, {
      restrict: "A",
      require: "ngModel",
      scope: {
        tags: "=ngModel"
      },
      template: '<ul class="tags">\n  <li ng-repeat="tag in tags">\n    <span class="inner-wrapper">\n      <a class="tag-link" href="{{url}}" target="_blank">{{tag.name}}</a>\n      <a class="remove-tag" href="javascript:;" ng-click="removeTag(tag)" title="移除"><i class="icon icon-remove-topic"></i></a>\n    </span>\n  </li>\n</ul>\n<input ui-suggest suggest-options="suggestOptions" class="basic-input" ng-class="{maxtags: tags.length == options.maxTags}" placeholder="{{options.placeholder}}">',
      controller: ["$scope", "$attrs",
        function(b, c) {
          return b.tags || (b.tags = []), b.options = angular.extend({}, a), angular.forEach(c, function(c, d) {
            return d in a ? b.options[d] = c : void 0
          }), b.validities = {}, b.updateValidities = function() {
            return this.validities.minTags = this.tags.length >= c.minTags, this.validities.maxTags = this.tags.length <= c.maxTags
          }, b.$watch("tags.length", function() {
            return b.updateValidities(), b.validate()
          }), b.removeTag = function(a) {
            return b.tags.splice(b.tags.indexOf(a), 1)
          }, b.suggestOptions = {
            source: "/api/autocomplete/topics",
            filter: function(a) {
              return a.filter(function(a) {
                return b.tags.every(function(b) {
                  return b.id !== a.id
                })
              })
            },
            select: function(a) {
              return b.tags.push(a), ""
            }
          }
        }
      ],
      link: function(a, b, c, d) {
        return a.validate = function() {
          return angular.forEach(this.validities, function(a, b) {
            return d.$setValidity(b, a)
          })
        }, d.$formatters.push(a.validate), d.$parsers.push(a.validate)
      }
    }
  })
}.call(this),
function() {
  app.directive("uiSuggest", ["$interpolate",
    function(a) {
      return {
        scope: {
          options: "=suggestOptions"
        },
        link: function(b, c, d) {
          var e, f, g;
          return f = {
            rowTemplate: '<div class="row">\n  <img class="avatar" src="{{avatar | avatarUrl:25}}">\n  <span class="name">{{name}}</span>\n</div>',
            fadeDuration: 100,
            source: d.source,
            renderTo: c.parent()[0],
            render: function(a, b, c) {
              return b.innerHTML = c.map(function(a) {
                return g(a.data)
              }).join("")
            }
          }, g = a(f.rowTemplate), angular.extend(f, b.options), f.select && (f.select = function(a) {
            return function(c) {
              return b.$apply(function() {
                return a(c)
              })
            }
          }(f.select)), e = new zh.ui.Suggest(c[0], f), b.$on("destroy", function() {
            return e.destroy()
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiSummary", ["$filter",
    function(a) {
      return {
        scope: {
          content: "=uiSummary"
        },
        link: function(b, c) {
          var d;
          return d = a("truncateHtml")(b.content, {
            details: !0
          }), d.truncated ? c.prepend(d.output) : c.html(d.output)
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiSpinner", ["support",
    function(a) {
      return {
        restrict: "A",
        replace: !0,
        template: '<div class="ui-spinner"></div>',
        link: function(b, c, d) {
          var e;
          return e = d.uiSpinner || a.cssAnimation && "use-css" || "use-gif", c.addClass(e)
        }
      }
    }
  ])
}.call(this),
function() {
  app.directive("uiTabTrigger", function() {
    return {
      restrict: "A",
      link: function(a, b, c) {
        var d, e, f;
        return d = 13, f = Number(c.uiTabTrigger) || d, e = function() {
          return angular.element("input, textarea, a, [contentEditable]").get()
        }, b.bind("keydown", function(a) {
          var b, c, d;
          return a.keyCode === f ? (a.preventDefault(), b = e(), c = b.indexOf(this), c && (d = b[c + 1]), d ? d.focus() : void 0) : void 0
        })
      }
    }
  })
}.call(this),
function() {
  app.directive("uiDroppable", function() {
    return function(a, b) {
      var c, d, e, f, g, h, i, j;
      return h = "droppable", c = "active", d = function(a) {
        return a.preventDefault(), a.stopPropagation(), a.dataTransfer.dropEffect = "copy"
      }, j = function(a) {
        return -1 !== a.dataTransfer.types.indexOf("Files") ? (a.dataTransfer.dropEffect = "none", a.preventDefault(), a.stopPropagation()) : void 0
      }, f = angular.element(document), g = {
        "dragover dragenter": function(a) {
          return j(a.originalEvent), b.addClass(c)
        },
        "drop dragleave": function() {
          return b.removeClass(c)
        }
      }, i = {
        "dragover dragenter": function(a) {
          return d(a.originalEvent), b.addClass(h)
        },
        "drop dragleave": function() {
          return b.removeClass(h)
        }
      }, e = function(a, b, c) {
        var d, e, f;
        f = [];
        for (d in c) e = c[d], f.push(a[b](d, e));
        return f
      }, e(f, "on", g), e(b, "on", i), a.$on("$destroy", function() {
        return e(f, "off", g), e(b, "off", i)
      })
    }
  })
}.call(this),
function() {
  var a = [].indexOf || function(a) {
    for (var b = 0, c = this.length; c > b; b++)
      if (b in this && this[b] === a) return b;
    return -1
  };
  app.directive("uiPopover", ["$parse", "$timeout",
    function(b, c) {
      return {
        restrict: "A",
        scope: !1,
        replace: !0,
        transclude: !0,
        template: '<div class="ui-popover" ng-show="show" ng-transclude></div>',
        link: function(b, d, e) {
          var f, g, h, i, j, k, l, m, n, o, p, q, r;
          return i = {
            align: "overlay",
            selector: "",
            container: document.body
          }, k = angular.extend(i, b.$eval(e.popoverOptions)), h = angular.element(k.container), o = k.selector, f = k.align, d.addClass(f), p = a.call(d[0].style, "pointerEvents") >= 0, l = function(a) {
            var b;
            return a.target === d[0] ? (d.hide(), b = document.elementFromPoint(a.clientX, a.clientY), d.show(), b.click()) : void 0
          }, r = "overlay" === f, r && !p && d.on("click", l), g = null, j = !1, q = function(a) {
            return a ? (j = !1, b.$apply(function() {
              return b.show = !0
            })) : (j = !0, c(function() {
              return j ? b.show = !1 : void 0
            }))
          }, n = {
            overlay: function() {
              return ["marginLeft", "marginRight", "marginTop", "marginBottom"].forEach(function(a) {
                return d.css(a, g.css(a))
              }), d.css(g.position()), d.width(g.width()), d.height(g.height())
            }
          }, m = function() {
            return n[f](g[0].getBoundingClientRect())
          }, d.on("mouseenter", function() {
            return q(!0)
          }).on("mouseleave", function() {
            return q(!1)
          }), h.on("mouseenter", o, function(a) {
            return g = angular.element(a.target), m(), q(!0)
          }).on("mouseleave", o, function() {
            return q(!1)
          }).on("input change", function() {
            return g && !h[0].contains(g[0]) ? q(!1) : void 0
          }), b.removeAnchor = function() {
            return g.remove(), g = null
          }, b.$on("$destroy", function() {
            return g = null
          })
        }
      }
    }
  ])
}.call(this),
function() {
  app.controller("AppCtrl", ["$scope", "$rootScope", "$location", "$timeout", "columnResolver", "dialog", "Column", "me", "loginDialog", "activateDialog", "sharedData", "globalAlert", "docTitle", "mediator", "bracketBlinkFix", "domainConfig",
    function(a, b, c, d, e, f, g, h, i, j, k, l, m, n) {
      return a.$on("$routeChangeStart", function(b, c) {
        return a.pageClass = c.pageClass
      }), a.$on("$routeChangeSuccess", function(a, e) {
        var f;
        return d(function() {
          return c.hash() ? void 0 : document.body.scrollTop = 0
        }), e.params.columnSlug ? (f = b.column, e.pageTitle ? m.push(e.pageTitle, f.name) : m.push(f.name)) : m.push(e.docTitle || e.pageTitle)
      }), b.me = h, n.subscribe(["column:create", "column:remove", "column:edit", "column:activate"], function() {
        return h.refresh()
      }), a.navbarTemplateUrl = "/views/navbar.html", a.globalAlert = l, n.subscribe("accountcallback", function(a) {
        return a.login ? (i.close(), h.refresh()) : this.returnValue = !1
      }), a.showLoginDialog = function() {
        return i.open(this)
      }, a.$on("event:loginRequired", function() {
        return a.showLoginDialog()
      }), a.$on("event:activateRequired", function() {
        return j.open(a)
      }), a.$on("event:notMutedRequired", function() {
        return f.message("由于多次违反社区规范，您的账户暂时无法发言")
      }), a.showNavColumnsSelector = function() {
        return a.navColumnsSelectorShow = !0
      }, a.writePostFor = function(a) {
        return k.set("selectedColumn", angular.extend({}, a)), c.url("/write")
      }, a.navToColumn = function(a) {
        return c.url("/" + a.slug)
      }
    }
  ])
}.call(this),
function() {
  app.controller("PostCommentsCtrl", ["$rootScope", "$scope", "$resource", "$location", "$anchorScroll", "$timeout", "dialog", "reportService", "requireActivate", "requireNotMuted", "me", "linkHeaderSource",
    function(a, b, c, d, e, f, g, h, i, j, k, l) {
      var m, n, o, p, q, r, s, t;
      return m = c(b.href + "/:id/:action", {
        id: "@id"
      }, {
        like: {
          method: "PUT",
          params: {
            action: "like"
          }
        },
        dislike: {
          method: "DELETE",
          params: {
            action: "like"
          }
        },
        reply: {
          method: "POST",
          params: {
            action: "reply"
          }
        }
      }), b.scraperOptions = {
        handlers: {
          image: function() {}
        }
      }, b.loadedOnce = !1, b.$watch("expanded", function(a) {
        return a && !b.loadedOnce ? b.loadComment() : void 0
      }), n = function() {
        return f(function() {
          var a;
          return a = d.hash(), "comments" === a ? e() : /^comment-\d+$/.test(a) ? angular.element("#" + a).length ? e() : angular.element("#comments")[0].scrollIntoView() : void 0
        })
      }, t = "" + b.href + "?limit=20", p = b.comments = [], s = b.source = l.create(t, p), r = function(a) {
        return !p.some(function(b) {
          return b.id === a.id
        })
      }, s.onadd = function(a) {
        return p.push.apply(p, a.filter(r).map(function(a) {
          return new m(a)
        }))
      }, s.onnext = function() {
        return s.url = s.url.replace(/limit=\d+/, "limit=50")
      }, b.pending = !0, b.loadComment = function() {
        return b.loadedOnce = !0, s.fetch()["finally"](function() {
          return n(), b.pending = !1
        })
      }, b.me = k, b.ownPost = function() {
        return k.slug === this.postOwner.slug
      }, b.ownComment = function(a) {
        return k.slug === a.author.slug
      }, b.canRemove = function(a) {
        return this.ownPost() || this.ownComment(a)
      }, b.isPostOwner = function(a) {
        return a && a.slug === this.postOwner.slug
      }, b.canReply = function(a) {
        return k.authed() && this.status.canComment && !this.ownComment(a)
      }, b.report = i(function(a) {
        return h(a, "comment", this)
      }), b.remove = function(a) {
        return g.confirm(this, "删除评论", "你确定要删除这条评论吗？", function() {
          var c;
          return b.status.count -= 1, c = p.indexOf(a), b.comments.splice(c, 1), a.$remove()
        })
      }, q = {
        content: ""
      }, b.editingComment = q, b.savePending = !1, o = function() {
        return b.savePending = !1
      }, b.addComment = i(j(function() {
        var a;
        return this.commentForm.$invalid ? g.message("评论内容必须填写") : (a = new m({
          content: q.content
        }), b.savePending = !0, a.$save(function(a) {
          return o(), q.content = "", b.status.count += 1, b.comments.push(a), b.formExpanded = !1
        }, o))
      })), b.like = i(function(a) {
        return a.liked = !a.liked, a.liked ? (a.likesCount += 1, a.$like()) : (a.likesCount -= 1, a.$dislike())
      }), b.formExpanded = !1, b.expandForm = i(j(function(a) {
        return b.formExpanded = a, !b.formExpanded && document.getSelection ? document.getSelection().removeAllRanges() : void 0
      })), b.toggleReplyForm = j(function(a) {
        return a.hidden = !a.hidden
      }), b.replyComment = i(j(function(a, c, d) {
        return d.$invalid ? g.message("回复内容必须填写") : (c.pending = !0, m.reply({
          id: a.id
        }, {
          content: c.content
        }, function(a) {
          return c.content = "", c.hidden = !0, c.pending = !1, b.status.count += 1, b.comments.push(a)
        }))
      }))
    }
  ])
}.call(this),
function() {
  app.controller("MainCtrl", ["$scope", "Recommendation",
    function() {}
  ])
}.call(this),
function() {
  app.controller("NavbarCtrl", ["$scope", "$rootScope", "$location", "columnResolver", "docTitle", "me",
    function(a, b, c, d, e, f) {
      return a.selectColumn = function(a, c) {
        return c.preventDefault(), c.stopPropagation(), b.$emit("columnSelectRequested", a)
      }, b.$on("columnSelectSuccess", function(b, c) {
        return a.selectedColumn = c
      }), b.$on("postEditRequested", function() {
        return a.columnSelectOnly = !0
      }), a.$on("$routeChangeStart", function() {
        return a.columnSelectOnly = !1
      }), a.$on("$routeChangeSuccess", function(b, c) {
        return a.pageTitle = c.pageTitle || ""
      }), a.toggleFollow = function(a, b) {
        return b.preventDefault(), b.stopPropagation(), a.toggleFollow()
      }, a.maxColumn = 5, a.$watch("me.columns", function(b) {
        var c;
        return f.columns ? a.minColumnsDisplay = (3 === (c = b.length) || c === a.maxColumn) && 3 || 2 : void 0
      })
    }
  ])
}.call(this),
function() {
  app.controller("EntryCtrl", ["$scope", "$rootScope", "$location", "Post",
    function() {}
  ]), app.controller("PostsCtrl", ["$scope", "$http", "column", "linkHeaderSource", "globalAlert", "mediator", "support",
    function(a, b, c, d, e, f, g) {
      var h;
      return a.supportsBackgroundSize = g.backgroundSize, h = "/api/columns/" + c.slug + "/posts", a.postsSource = d.create(h, a.posts = []), a.ownColumn = function() {
        return c.creator.slug === a.me.slug
      }, a.activateAuthor = function() {
        var d;
        return d = "" + c.href + "/authors/" + a.me.slug + "/activate", b.put(d).success(function() {
          return f.publish("column:activate", c), c.canPost = !0, e.set("你已经成为该专栏的作者")
        })
      }
    }
  ])
}.call(this),
function() {
  app.controller("PostWriteCtrl", ["$scope", "$rootScope", "$q", "$timeout", "$location", "$http", "dialog", "$window", "sharedData", "Post", "draft", "Draft", "me", "domainConfig", "globalAlert", "preventUnload", "debounce", "requireNotMuted",
    function(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r) {
      var s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H, I, J, K;
      return A = ["title", "content", "titleImage", "column", "sourceUrl"], a.$emit("postEditRequested"), J = !0, p(a, "你的草稿可能还未保存", function() {
        return J && !k.id && (k.titleImage || k.content)
      }), x = k.id, x || A.forEach(function(a) {
        return k[a] = ""
      }), a.draft = k, w = function(b) {
        return a.$emit("columnSelectSuccess", b)
      }, H = i.get("selectedColumn"), H ? (k.column = H, i.remove("selectedColumn")) : 1 === m.columns.length && (k.column = m.columns[0]), k.id && (z = !0), D = function(a, b) {
        return b.reduce(function(b, c) {
          return b[c] = a[c], b
        }, {})
      }, v = function(a, b, c) {
        return (c || Object.keys(a)).map(function(c) {
          return angular.equals(a[c], b[c]) ? void 0 : c
        }).filter(Boolean)
      }, E = function(a) {
        return D(a, ["slug", "name", "image"])
      }, t = function() {
        return a.$watch("draft", function(b, c) {
          return a.saveDraft(v(b, c, A))
        }, !0)
      }, d(function() {
        return t()
      }), a.back = function() {
        return h.history.back()
      }, F = /[^\x00-\x7F]/g, u = function(a) {
        return a ? a.replace(F, "--").length : 0
      }, a.errorHint = "", C = 1e5, a.onContentChange = function(b) {
        var c, d;
        return d = b.target.textContent, c = C - Math.ceil(u(d.trim()) / 2), a.errorHint = 0 > c ? "超出 " + -c + " 字" : ""
      }, s = 500, a.draftSaving = !1, G = q(500, function(b) {
        var e, f;
        return f = c.defer(), e = d(function() {}, s), c.all([f, e]).then(function() {
          return a.draftSaving = !1
        }), l.patch({
          draftId: k.id
        }, D(k, b), function() {
          return f.resolve()
        })
      }), a.draftCreating = !1, I = function() {
        var b;
        return b = a.postForm, !a.draftCreating && (b.title.$valid || b.content.$valid)
      }, a.saveDraft = function(b) {
        if (!y)
          if (k.id) {
            if (b.length) return a.draftSaving = !0, G(b)
          } else if (I()) return a.draftCreating = !0, l.create(k, function(b) {
          return a.draftCreating = !1, k.id = b.id
        }, function() {
          return a.draftCreating = !1
        })
      }, a.removeDraft = function(a) {
        return a.$remove(function() {
          return o.set("草稿删除成功"), e.url(z && a.url ? a.url : "/drafts")
        })
      }, y = !1, a.publish = r(function() {
        return a.postForm.title.$invalid ? g.message("你还没有填写标题") : a.postForm.content.$invalid ? g.message("你还没有写下任何内容") : !y && k.id ? k.column ? (y = !0, k.$publish().then(function(a) {
          return J = !1, "censoring" === a.state ? (o.set("文章正在审核", "warn"), e.url("/drafts")) : (o.set(z ? "文章修改已发布" : "文章已发布"), e.url(a.url))
        }, function(a) {
          var b, c, d;
          return y = !1, b = a.data, c = (null != (d = b.errors) ? d.length : void 0) ? b.errors.map(function(a) {
            return a.message
          }).join("<br>") : b.message || "抱歉，程序出了些问题，请稍后再试", g.message(c)
        })) : a.showColumnSelector() : void 0
      }), a.$watch("draft.column", function(a) {
        return w(a)
      }), b.$on("columnSelectRequested", function() {
        return a.showColumnSelector()
      }), a.selectColumn = function(a) {
        return k.column = E(a)
      }, a.showColumnSelector = function() {
        return a.columnsSelectorShow = !0
      }, B = "localhost" === e.host(), K = B ? "/upload" : n.uploadUrl, a.fileuploadOptions = {
        url: K,
        autoUpload: !0,
        dropZone: angular.element("#js-title-img"),
        pasteZone: angular.element(),
        formData: {
          via: "xhr2"
        },
        xhrFields: {
          withCredentials: !0
        },
        processalways: function(a, b) {
          var c;
          return c = b.files[b.index], c.error ? o.setSync(c.error, "error") : void 0
        },
        done: function(a, b) {
          var c;
          return c = b.result, B ? k.titleImage = c[0].url : 0 === c.code ? k.titleImage = c.msg[0] : void 0
        }
      }
    }
  ])
}.call(this),
function() {
  app.controller("PostViewCtrl", ["$scope", "$rootScope", "$location", "$rootElement", "$resource", "$sce", "$http", "dialog", "globalAlert", "snsShare", "docTitle", "resources", "requireActivate", "reportService", "me", "memoize",
    function(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p) {
      var q, r, s, t, u, v, w, x, y, z;
      return x = l.post, t = l.column, a.post = x, a.postContentTrustedHtml = f.trustAsHtml(x.content), k.push(x.title, t.name), a.ownPost = function(a) {
        var c;
        return (null != (c = a.author) ? c.slug : void 0) === b.me.slug
      }, w = function(a) {
        var b;
        return b = x.meta, a && b && b[a] ? c.url(b[a].url) : void 0
      }, v = function(b) {
        var c, d;
        return d = b.target, d.isContentEditable || /^(input|textarea)$/i.test(d.nodeName) ? void 0 : (c = {
          37: "previous",
          39: "next"
        }, a.$apply(function() {
          return w(c[b.keyCode])
        }))
      }, d.bind("keydown", v), a.$on("$destroy", function() {
        return d.unbind("keydown", v)
      }), a.editPost = function() {
        return c.url("" + x.url + "/edit")
      }, a.removePost = function() {
        return h.confirm(this, "删除文章", "你确定要删除这篇文章吗？", function() {
          return x.remove(function() {
            return c.url("/" + t.slug), i.set("文章删除成功")
          })
        })
      }, a.editMenuItems = [{
        label: "修改",
        icon: "icon-postedit",
        action: a.editPost
      }, {
        label: "删除",
        icon: "icon-postdel",
        action: a.removePost
      }], y = function(b) {
        var d, e, f;
        return d = a.post.author.name, e = {
          title: t.name + " - " + x.title,
          url: c.absUrl()
        }, x.snapshotUrl && (e.pic = x.snapshotUrl), f = function() {
          return j.share(b, d, e)
        }, "sina" === b ? s().error(f).then(function(a) {
          var b, c;
          return b = null != (c = a.data.sina) ? c.name : void 0, b && (d = "@" + b), f()
        }) : f()
      }, s = function(b) {
        return function() {
          return b("/api/users/" + a.post.author.slug + "/connections")
        }
      }(p(g.get)), a.beforeShareMenuOpen = function() {
        return s()
      }, a.shareMenuItems = [{
        label: "新浪微博",
        icon: "icon-share-sina",
        action: function() {
          return y("sina")
        }
      }, {
        label: "腾讯微博",
        icon: "icon-share-qq",
        action: function() {
          return y("qq")
        }
      }, {
        label: "Twitter",
        icon: "icon-share-twitter",
        action: function() {
          return y("twitter")
        }
      }, {
        label: "豆瓣",
        icon: "icon-share-douban",
        action: function() {
          return y("douban")
        }
      }], r = e("" + x.href + "/topics/:id", {
        id: "@id"
      }), a.unbindTopic = function(a, b) {
        return x.topics.splice(b, 1), r.remove({
          id: a.id
        })
      }, a.bindTopic = function(a) {
        return x.topics.push(a), r.save({
          id: ""
        }, a)
      }, a.suggestOptions = {
        source: "/api/autocomplete/topics",
        filter: function(a) {
          return a.filter(function(a) {
            return x.topics.every(function(b) {
              return b.id !== a.id
            })
          })
        },
        select: function(b) {
          return a.bindTopic(b), ""
        }
      }, q = e("" + x.href + "/likers"), a.fetchAllLikers = function() {
        return a.fetchLikersPending = !0, q.query(function(b) {
          return a.fetchLikersPending = !1, a.likers = b
        })
      }, u = function(a, b) {
        var c;
        return c = -1, a.some(function(a, d) {
          return a.slug === b.slug ? (c = d, !0) : void 0
        }), c
      }, z = function() {
        var b, c;
        if (c = a.likers || a.post.lastestLikers, b = u(c, o), "like" === a.post.rating) {
          if (-1 === b) return c.unshift(o)
        } else if (-1 !== b) return c.splice(b, 1)
      }, a.$watch("post.rating", z), a.commentsStatus = {
        count: x.commentsCount,
        canComment: x.canComment,
        permission: x.commentPermission
      }, a.report = m(function(a) {
        return n(a, "post", this)
      })
    }
  ])
}.call(this),
function() {
  app.controller("ColumnCreateCtrl", ["$scope", "betaStatus",
    function(a, b) {
      return a.betaStatus = b
    }
  ]), app.controller("ColumnEditCtrl", ["$scope", "$rootScope", "$timeout", "$anchorScroll", "$routeParams", "$location", "$window", "dialog", "Column", "domainConfig", "globalAlert", "docTitle", "mediator", "editAvatar",
    function(a, b, c, d, e, f, g, h, i, j, k, l, m, n) {
      var o, p, q, r, s, t, u, v;
      return c(function() {
        return d()
      }), p = e.columnSlug, a.editMode = !!p, a.column = a.editMode ? angular.copy(b.column) : new i({
        avatar: {
          id: "",
          template: ""
        },
        slug: "",
        name: "",
        image: "",
        topics: [],
        description: "",
        acceptSubmission: !1,
        commentPermission: "anyone"
      }), a.validatorEnabled = !1, t = function(a) {
        var b, c;
        return b = (null != (c = a.errors) ? c.length : void 0) ? a.errors.map(function(a) {
          return a.message
        }).join("<br>") : a.message, h.message(b)
      }, a.create = function(b) {
        return a.validatorEnabled = !0, a.columnForm.$valid ? b.$save({
          columnSlug: ""
        }, function(a) {
          return f.url(a.slug), k.set("专栏创建成功"), m.publish("column:create", b)
        }, function(a) {
          var b;
          return b = a.data, b ? t(b) : h.message("专栏创建失败")
        }) : void 0
      }, u = "localhost" === f.host(), v = u ? "/upload" : j.avatarUploadUrl, o = {
        type: 3,
        return_size: "xl"
      }, a.editMode && (o.dest_id = p), r = function(b, c) {
        return loadImage.readFile(b, function(b) {
          return a.$apply(function() {
            return c(b.target.result)
          })
        })
      }, q = function(b, c) {
        return n(a, b, c)
      }, s = {
        loadImageMaxFileSize: 15e6,
        imageMaxWidth: 1e3,
        imageMaxHeight: 1e3,
        disableImagePreview: !0,
        url: v,
        autoUpload: !0,
        formData: o,
        xhrFields: {
          withCredentials: !0
        },
        add: function(a, b) {
          var c, d;
          return c = b.files[0], d = c.name, r(c, function(a) {
            return q(a, function(a) {
              var c;
              return c = dataURLtoBlob(a.dataUrl), c.name = d, b.files[0] = c, b.submit()
            })
          })
        },
        processalways: function(a, b) {
          var c;
          return c = b.files[b.index], c.error ? k.setSync(c.error, "error") : void 0
        },
        done: function(b, c) {
          var d;
          return d = c.result, d.r ? h.message(d.msg) : u ? a.column.avatar = d[0].avatar : (a.column.avatar.template = d.url, a.column.avatar.id = d.id)
        }
      }, a.fileuploadOptions = s, a.edit = function(c) {
        return a.validatorEnabled = !0, a.columnForm.$valid ? c.$patch({
          columnSlug: p
        }, function(a) {
          return b.column && angular.extend(b.column, a), f.url(a.slug), k.set("专栏修改成功"), m.publish("column:edit", c)
        }, function(a) {
          return t(a.data)
        }) : void 0
      }, a.remove = function(a) {
        return a.$remove(function() {
          return f.url("/"), k.set("专栏删除成功"), m.publish("column:remove", a)
        })
      }, a.back = function() {
        return g.history.back()
      }
    }
  ])
}.call(this),
function() {
  app.controller("ColumnAuthorsEditCtrl", ["$scope", "$resource", "dialog",
    function(a, b, c) {
      var d, e;
      return d = b("" + a.column.href + "/authors/:slug", {
        slug: "@slug"
      }), e = a.authors = d.query({
        filter: "all"
      }), a.notMe = function(b) {
        return b.slug !== a.me.slug
      }, a.removeAuthor = function(a) {
        return a.$remove(), e.splice(e.indexOf(a), 1)
      }, a.invite = function(a) {
        var b;
        return b = new d(a), b.$save({
          slug: ""
        }, function() {
          return e.push(b)
        }, function(a) {
          return c.message(a.data.message || "抱歉，程序出了些问题，请稍后再试")
        })
      }, a.suggestOptions = {
        source: "/api/autocomplete/users",
        filter: function(a) {
          return a.filter(function(a) {
            return e.every(function(b) {
              return b.slug !== a.slug
            })
          })
        },
        select: function(b) {
          return a.invite(b), ""
        }
      }
    }
  ])
}.call(this),
function() {
  app.controller("ColumnFollowersCtrl", ["$scope", "$resource", "column", "linkHeaderSource",
    function(a, b, c, d) {
      var e;
      return e = "" + c.href + "/followers", a.source = d.create(e, a.followers = [])
    }
  ])
}.call(this),
function() {
  app.controller("DraftsCtrl", ["$scope", "linkHeaderSource", "Draft", "$window", "$timeout", "$http",
    function(a, b, c, d, e, f) {
      var g;
      return g = "/api/me/drafts", a.draftsSource = b.create(g, a.drafts = []), a.removeDraft = function(b, f) {
        return b = new c(b), b.$remove(), a.drafts.splice(f, 1), a.draftsSource.count && (a.draftsSource.count -= 1), angular.element(d).scroll(), a.animating = !0, e(function() {
          return a.animating = !1
        }, 300)
      }, a.removeAllDrafts = function() {
        return f({
          method: "DELETE",
          url: g
        }).success(function() {
          return a.drafts = [], a.draftsSource.count = 0, a.draftsSource.completed = !0
        })
      }
    }
  ])
}.call(this),
function() {
  app.factory("editAvatar", ["dialog",
    function(a) {
      return function(b, c, d) {
        return a.fromUrl("/scripts/avatar/avatar-editor.html", {
          controller: "AvatarEditorCtrl",
          scope: b,
          resolve: {
            src: c,
            submit: d
          }
        }).then(function(a) {
          return a.open()
        })
      }
    }
  ]), app.controller("AvatarEditorCtrl", ["$scope", "src", "submit", "element",
    function(a, b, c, d) {
      var e, f;
      return f = 0 === b.indexOf("data:image"), e = new zh.ui.ImageCrop(b), e.render(d.find(".modal-dialog-content")[0]), a.submit = function() {
        var a;
        return a = f ? {
          dataUrl: e.toDataUrl()
        } : {
          rect: e.getRect()
        }, c(a)
      }
    }
  ])
}.call(this),
function() {
  app.factory("debounce", ["$timeout",
    function(a) {
      return function(b, c) {
        var d;
        return d = null,
          function() {
            return a.cancel(d), d = a(c.apply.bind(c, this, arguments), b)
          }
      }
    }
  ])
}.call(this),
function() {
  app.factory("memoize", ["$timeout",
    function() {
      return function(a) {
        var b;
        return b = {},
          function(c) {
            return b[c] ? b[c] : b[c] = a(c)
          }
      }
    }
  ])
}.call(this),
function() {
  app.factory("support", function() {
    var a;
    return a = document.body.style, {
      cssAnimation: ["animation", "webkitAnimation"].some(function(b) {
        return b in a
      }),
      backgroundSize: "backgroundSize" in a
    }
  })
}.call(this),
function() {
  app.service("bracketBlinkFix", ["$rootScope", "$window", "$timeout",
    function(a, b, c) {
      var d, e;
      return e = /Mobile/.test(b.navigator.userAgent), d = function() {
        var b, d;
        return d = angular.element("[ng-view]"), b = function() {
          return d.addClass("hidden"), c(function() {
            return d.removeClass("hidden")
          })
        }, a.$on("$routeChangeSuccess", b), a.$on("$routeChangeError", b)
      }, e ? d() : void 0
    }
  ])
}.call(this);