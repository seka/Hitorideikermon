module.exports = (options) ->
  config = options.config.database
  sequelize = require './node_modules/sequelize'

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

  # database オブジェクトの定義
  columns = {
    userid : {type: sequelize.STRING(30)}
    SEQ : sequelize.INTEGER
    latitude : sequelize.DECIMAL(20, 17)
    parallel : sequelize.DECIMAL(20, 17)
    pic : sequelize.BLOB
  }
  database.parentsTable = seq.define('parents', columns, seq_option)

  columns = {
    userid : {type: sequelize.STRING(30)}
    SEQ : sequelize.INTEGER
    safelatitude : sequelize.DECIMAL(20, 17)
    safeparallel : sequelize.DECIMAL(20, 17)
  }
  database.safeareaTable = seq.define('safearea', columns, seq_option)

  columns = {
    userid : {type: sequelize.STRING(30)}
    shootseq : sequelize.INTEGER
    shootlatitude : sequelize.DECIMAL(20, 17)
    shootparalled : sequelize.DECIMAL(20, 17)
    shootpic : sequelize.BLOB
    regtime : sequelize.DATE
  }
  database.childShootTable = seq.define('childshoot', columns, seq_option)



  return database
# ------------------------------------


