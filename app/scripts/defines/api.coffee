LOC = location
IsDebug = LOC["port"] is "9000"

BASE_API_PATH = "/mifan/service/index.php"

API = 
  user: "/user/usersession/user"
  userInfo: "/user/userinfo/user/id" # 1
  ask: "/ask/askinfo/ask"
  news: "/feed/feedinfo/feeds"
  msgcount: "/common/message/msgcount"

if IsDebug
  BASE_API_PATH = "/data"

  API = 
    user: "/user.json"
    userInfo: "/user-info.json"
    ask: "/ask.json"
    news: "/news.json"
    msgcount: "/msgcount.json"

API[api] = "#{BASE_API_PATH}#{API[api]}" for api of API