LOC = location
IsDebug = LOC["port"] is "9000"

BASE_API_PATH = "/api/index.php"

API = 
  user: "/user/usersession/user"
  userInfo: "/user/userinfo/user/id" # 1
  ask: "/ask/askinfo/ask"
  news: "/feed/feedinfo/feeds"
  notice: "/common/message/msgcount"
  myask: "/user/me/myask"
  myanswer: "/user/me/myanswer"
  askme: "/ask/askinfo/asks"

if IsDebug
  BASE_API_PATH = "/data"

  API = 
    user: "/user.json"
    userInfo: "/user-info.json"
    ask: "/ask.json"
    news: "/news.json"
    myask: "/myask.json"
    myanswer: "/myanswer.json"
    notice: "/msgcount.json"
    askme: "/askme.json"

API[api] = "#{BASE_API_PATH}#{API[api]}" for api of API