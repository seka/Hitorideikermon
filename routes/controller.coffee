module.exports = (option) ->
  # -------------------------------
  # server instance
  # -------------------------------
  app = option.app
  dataBase = option.database

  # ------------------------------
  # 親のルート
  # ------------------------------
  ###
  app.get '/', (req, res) ->
    res.render 'login', {
      title : "test"
    }
  ###
  #
  app.get '/', (req, res) ->
    res.render 'index', {
      title : "test"
  }

  require('./Save/SaveLocation').SaveLocationController(option)
  require('./Load/LoadLocation').LoadLocationController(option)



  # ready msg ----------------------
  return "controller is setup"

