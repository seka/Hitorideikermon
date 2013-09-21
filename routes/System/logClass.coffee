exports.LogConfig = class LogConfig
  _size = 1024 * 1024
  _date = '-yyyy-MM-dd'

  constructor : (dir) ->
    @dir = dir
  getName : () ->
    "#{@dir}/logs/app.log"
  getSize   : () ->
    _size
  getStdout : () ->
    false
  getPattern : () ->
    _date
  getNolog  : () ->
    [ '\\.css', '\\.js', '\\.gif', '\\.jpg', '\\.png' ]
  format : () ->
    JSON.stringify {
      'method'     : ':method'
      'request'    : ':url'
      'status'     : ':status'
      'user-agent' : ':user-agent'
    }
