# ---- main --------------------------------------------------
exports.main = (req, res, dataBase) ->
  async = require 'async'
  fs = require 'fs'
  informChild = new InformChild(req, res, dataBase, fs)

  async.series([
    informChild.getTweet
    , informChild.resStatusJson
  ], (err, result) ->
    if (err)
      throw err
      res.redirect '/'
    console.log "coding all done. #{result}"
  )

class InformChild
  constructor : (@req, @res, @dataBase, @fs, ) ->
    # user info -------------------
    @userid = @req.body.username
    @latitude = @req.body.latitude
    @parallel = @req.body.longitude
    @upload = @req.files.upfile
    @resJson = []

    # database --------------------
    @parentsTable = @dataBase.informChildTable

  # getTweet ----------
  # 子供のつぶやいたリストの取得
  getTweet : (callBack) =>
    @informChildTable.findAll(
      where : {
        userid : @userid
      }
    ).success (columns) =>
      if (columns[0]?)
        for column, i in columns
          @resJson[i] = {
            latitude : column.shootlatitude
            paralled : column.shootparalled
            shootpic : new String(column.pic)
            regtime : column.time
          }
      callBack(null, 1)
    .error (err) ->
      console.log "load informChildTable Err >> #{err}"

  # ---- resStatus -------------------------------------
  resStatusJson : (callBack) =>
    obj = {
      status : 200
      data : @resJson
      error: false
    }
    @res.json obj
    callBack(null, 2)

