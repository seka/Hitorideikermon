module.exports = (options) ->
  config = options.config.database
  sequelize = require '../sequelize'

  # databaseの定義を記述する
  # database名、ユーザ、パスワード、ホストネーム、ポート
  # ホストネームはサーバのip?
  dbname = config.dbname
  dbuser = config.dbuser
  dbpass = config.local_pass
  hostname = config.hostname
  portnum = config.port

  seq = new sequelize(dbname, dbuser, dbpass, {
    host: hostname
    port: portnum
  })

  database = new Object()

  # defaultで付与されるタイムスタンプを付けない
  # テーブルネームを複数形にしない（定義した名前を使用する）
  seq_option = {
    timestamps     : false
    freezeTableName: true
  }

  # O/Rマッパーがサポートしていない範囲のSQLを発行する
  database.seq = seq

  # sample
  columns = {
    questionNo: {type: sequelize.STRING, primaryKey: true}
    answer: sequelize.TEXT
    testcase: sequelize.TEXT
  }
  database.answerTable = seq.define('Answer_table', columns, seq_option)

  return database
# ------------------------------------


