module.exports = (option) ->
  # -------------------------------
  # server instance
  # -------------------------------
  app = option.app
  dataBase = option.database

  # ------------------------------
  # 親のルート
  # ------------------------------
  app.get '/', (req, res) ->
    res.render 'index', {
      title : "test"
    }

  require('./Save/SaveLocation').SaveLocationController(option)

  # ready msg ----------------------
  return "controller is setup"

