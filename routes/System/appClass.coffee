exports.AppConfig = class AppConfig
  # ファイル名に拡張子を残すか
  _keepExtention = true
  _engine = "ejs"

  constructor : (port, dir) ->
    @port = port
    # ディレクトリ
    @tmpDir = "#{dir}/tmp"
    @view   = "#{dir}/views"
    @public = "#{dir}/public"

  getPort  : () ->
    return @port
  getView : () ->
    return @view
  getPublic : () ->
    return @public
  getEngine : () ->
    return _engine
  upload : () ->
    return {
      uploadDir        : @tmpDir
      isKeepExtensions : _keepExtention
    }
