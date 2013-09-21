# ---- main --------------------------------------------------
exports.main = (req, res, dataBase) ->
  async = require 'async'
  fs = require 'fs'
  saveLocation = new SaveLocation(req, res, dataBase, async, fs)

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

class SaveLocation
  constructor : (@req, @res, @dataBase, @async, @fs) ->
    # user info -------------------
    @latitude = @req.body.latitude
    @parallel = @req.body.longitude
    @upload = @req.files.upfile

    # database --------------------
    @parentsTable = @dataBase.parentsTable

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
      "userid" : "test"
      "SEQ" : "300"
      "latitude" : @latitude
      "parallel" : @parallel
      "pic" : bufImage
    }

    saveData = @parentsTable.build(insert_obj)

    saveData.save().success () =>
      console.log 'locationTable save success'
      callBack(null, 3)
    .error (err) ->
      console.log "locationTable Save Error => #{err}"

  # ---- resStatus -------------------------------------
  resStatusJson : (callBack) =>
    obj = {
      status : 200
      filename: @upload.name
      error: false
    }
    @res.json obj
    callBack(null, 6)

  # remove_dir --------------
  # 作業ファイルの削除
  ###
  removeTmpfile : (callBack) =>
    imagePath = "#{@TARGET_PATH}#{@upload.name}"
    cmd = "rm -rf #{imagePath}"
    exec cmd, {}, (err, stdout, stderr) =>
      if (err)
        console.log "rm error -> #{err}"
      callBack(null, 10)
###
