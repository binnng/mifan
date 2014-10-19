LOC = location
IsDebug = LOC["port"] is "9000"

BASE_API_PATH = "/api/index.php"

API = 
  user: "/user/usersession/user"
  userInfo: "/user/userinfo/user/id" # 1
  ask: "/ask/askinfo/ask"
  answer: "/ask/askinfo/answer"
  news: "/feed/feedinfo/feeds"
  notice: "/common/message/msgcount"
  myask: "/user/me/myask"
  myanswer: "/user/me/myanswer"
  askme: "/ask/askinfo/asks"
  follow: "/user/friend/follow"
  unfollow: "/user/friend/unfollow"
  loveanswer: "/ask/askinfo/loveanswer"
  answerme: "/feed/feedinfo/answerme"
  comment: "/ask/askinfo/comment"
  getComment: "/ask/askinfo/comments"
  loveme: "/user/feedinfo/loveanswers"


if IsDebug
  BASE_API_PATH = "/data"

  API = 
    user: "/user.json"
    userInfo: "/user-info.json"
    ask: "/ask.json"
    answer: "/answer.json"
    news: "/news.json"
    myask: "/myask.json"
    myanswer: "/myanswer.json"
    notice: "/msgcount.json"
    askme: "/askme.json"
    follow: "/follow.json"
    unfollow: "/unfollow.json"
    loveanswer: "/loveanswer.json"
    answerme: "/answerme.json"
    comment: "/comment.json"
    getComment: "/comments_list.json"
    loveme: "/loveanswers.json"

API[api] = "#{BASE_API_PATH}#{API[api]}" for api of API