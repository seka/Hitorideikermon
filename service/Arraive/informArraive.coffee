# ---- main --------------------------------------------------
exports.main = (req, res, dataBase) ->
  async = require 'async'
  fs = require 'fs'
  informArraive = new InformArraive(req, res, dataBase, async, fs)

  async.waterfall([
    saveLocation.mvTmpfile
    , saveLocation.imgEncode
    , saveLocation.saveData
    , saveLocation.resStatusJson
  ], (err, result) ->
    if (err)
      throw err
      res.redirect '/'
    console.log "coding all done. #{result}"
  )

class DateFormat
  _digits = (digits, n) ->
    if "#{n}".length >= digits
      "#{n}"
    else
      pad = digits - "#{n}".length
      "#{(new Array(pad + 1)).join("0")}#{n}"

  constructor: () ->
    @date = new Date()

  toString:  ->
    year  = @date.getYear()
    month = _digits 2, @date.getMonth() + 1
    d  = _digits 2, @date.getDate()
    hour  = _digits 2, @date.getHours()
    min   = _digits 2, @date.getMinutes()
    sec   = _digits 2, @date.getSeconds()
    "#{year}/#{month}/#{d} #{hour}:#{min}:#{sec}"

  @format: () ->
    "#{new DateFormat()}"

class InformArraive
  constructor : (@req, @res, @dataBase, @async, @fs) ->
    # user info -------------------
    @userid = @req.body.userid
    @shootseq = @req.body.seq
    @shootlatitude = @req.body.latitude
    @shootparallel = @req.body.parallel
    @upload = @req.files.upfile
    @regtime = new DateFormat().format

    # database --------------------
    @childshootTable = @dataBase.childShootTable

    # private
    @TMP_PATH = @req.files.upfile.path
    @TARGET_PATH = __dirname + '/../../public/uploaded/'

  # mvTmpfile ---------------------------------------------
  mvTmpfile : (callBack) =>
    # ファイルリクエストは一時ファイル扱いとして、tmpに適当な名前をつけてあるので
    # target_pathへコピーし、名前を変更する
    imagePath = "#{@TARGET_PATH}#{@upload.name}"
    @fs.rename @TMP_PATH, imagePath, (err) =>
      if (err)
        throw err
        console.log "fileupload mv err"
      console.log "tmpFilerename done."
      callBack(null, 1, imagePath)

  # imgEncode -------------------------------------------
  imgEncode : (num, imagePath, callBack) =>
    @fs.readFile imagePath, (err, data) =>
      if (err)
        throw err
        console.log "encode err"
      callBack(null, 2, new Buffer(data).toString('base64'))

  # ---- saveData --------------------------------------
  saveData : (num, bufImage, callBack) =>
    insert_obj = {
      userid : @userid
      shootseq : @shootseq
      shootlatitude : @latitude
      shootparallel : @parallel
      shootpic : bufImage
      regtime : @regtime
    }

    saveData = @childshootTable.build(insert_obj)

    saveData.save().success () =>
      console.log 'shootTable save success'
      callBack(null, 3)
    .error (err) ->
      console.log "shootableTable Save Error => #{err}"

  # ---- resStatus -------------------------------------
  resStatusJson : (callBack) =>
    obj = {
      status : 200
      filename: @upload.name
      error: false
    }
    @res.json obj
    callBack(null, 6)
