module.exports = (option) ->
  # -------------------------------
  # server instance
  # -------------------------------
  app = option.app
  dataBase = option.database

  # ------------------------------
  # 親のルート
  # ------------------------------
  require('./save/location').SaveLocation(option)


  # ready msg ----------------------
  return "controller is setup"

