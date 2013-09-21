exports.SessionConfig = class SessionConfig
  # trueにするとJavascriptなどからアクセスできなくなる
  _access = false
  # millisec (default: 60000)
  # 60 * 60 * 1000 = 3600000 msec = 1 hour (設定しないとブラウザを終了したときsession切れる
  _interval = 60 * 60 * 1000 * 24
  _limit  = new Date(Date.now() + _interval)

  constructor : (express, appOption) ->
    @secret = appOption.session.session_secret

  getMemoryStore : () ->
    return @sessionstore

  getSecret : () ->
    return @secret

  getCookie : () ->
    return {
      httpOnly  : _access
      maxAge    : _limit
    }

