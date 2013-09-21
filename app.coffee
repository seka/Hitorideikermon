### ------- Module dependencies. ------------ ###
express = require 'express'
engine  = require 'ejs-locals'
http = require 'http'
log4js  = require 'crafity-log4js'
app = express()

### ------- Class --------------------------- ###
appOption = require './config/option.json'
AppClass = require './routes/System/appClass'
LogClass = require './routes/System/logClass'
SessionClass = require './routes/System/sessionClass'

appConfig = new AppClass.AppConfig(appOption.app.app_port, __dirname)
logConfig = new LogClass.LogConfig(__dirname)
sessionConfig = new SessionClass.SessionConfig(express, appOption)

### ------- middleware ------------------------ ###
# expressの公式に起動の順番に注意とある
# 順番どおりに起動している
app.configure ->
  app.set 'port',  appConfig.getPort()
  app.set 'views', appConfig.getView()
  app.engine 'ejs', engine
  app.set 'view engine', appConfig.getEngine()
  app.use express.favicon()

  # log -----------------------
  logger = log4js.getLogger 'file'
  log4js.configure(
    appenders : [
      {'type': 'console'}
      {
        'type'       : 'file'
        'filename'   : logConfig.getName()
        'maxLogSize' : logConfig.getSize()
        'pattern'    : logConfig.getPattern()
        'category'   : 'console'
      }
    ]
    replaceConsole : logConfig.getStdout()
  )
  app.use log4js.connectLogger logger, {
    nolog  : logConfig.getNolog()
    format : logConfig.format()
  }

  # 応答データの圧縮
  app.use express.compress()

  # upload 先の設置
  # Parser -> エラーが無ければ以下の3つを順に実行していく
  # content-type='apllication/json'->middleware/json.jsを使い.req.bodyにJSON.parse()の結果を付与
  # content-type='application/x-www-form-urlencoded'->req.bodyにテキストの一般的なWebFormの入力値を付与
  # content-type='multipart/form-data'->middleware/multipart.jsを使いreq.body, req.files に結果が付与
  # postのリクエスト処理
  app.use express.bodyParser appConfig.upload()

  # session -------------------
  app.use express.cookieParser sessionConfig.getSecret()
  ###
  app.use express.session(
    secret : sessionConfig.getSecret()
  )
  ###

  app.use express.methodOverride()
  app.use express.static appConfig.getPublic()

  console.log "app opption setup."

### ------- create httpServer.----------------- ###
# app server listen
server = http.createServer(app)
# database -> controllerの起動
server.listen app.get('port'), ->
  console.log "Master Server listening on #{app.get('port')}"
  # database setup
  database_root = "./database/database"
  database = require(database_root)(config : appOption)

  # controller setup
  timer_id = setTimeout(
    ->
      controller = "#{__dirname}/routes/controller"
      console.log "#{require(controller)(app : app, database : database)}"
    100
  )

### ------- Error. ----------------------------------------- ###
# nodeがERRによって突然死しないようにする
process.on 'uncaughtException', (err) ->
  console.log "err >  #{err}"
  console.error "uncaughtException > #{err.stack}"
