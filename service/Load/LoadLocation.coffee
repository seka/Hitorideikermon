# ---- main --------------------------------------------------
exports.main = (req, res, dataBase) ->
  async = require 'async'
  loadLocation = new LoadLocation(req, res, dataBase, async)

  async.series([
    loadLocation.getImage
    , loadLocation.resStatusJson
  ], (err, result) ->
    if (err)
      throw err
      res.redirect '/'
    console.log "coding all done. #{result}"
  )
class LoadLocation
  constructor : (@req, @res, @dataBase, @async) ->
    # user info -------------------
    @userid = "test"
    @resJson = {}
    @pics = []

    # database --------------------
    @parentsTable = @dataBase.parentsTable

  # getImage ----------
  # 画像リストの取得
  getImage : (callBack) =>
    @parentsTable.findAll(
      where : {
        userid : @userid
      }
    ).success (columns) =>
      if (columns[0]?)
        for column, i in columns
          console.log new String(column.pic)
          @resJson[i] = {
            seq : column.seq
            pic : new String(column.pic)
          }
      callBack(null, 1)
    .error (err) ->
      console.log "load parentsTable Err >> #{err}"

  # ---- resStatus -------------------------------------
  resStatusJson : (callBack) =>
    obj = {
      status : 200
      data : @resJson
      error: false
    }
    @res.json obj
    callBack(null, 2)

