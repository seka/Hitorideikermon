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
    res.render 'index', {
      title : "test"
    }
  ###

  app.get '/', (req, res) ->
    res.render 'login', {
      title : "test"
    }

  app.get '/route', (req, res) ->
    res.render 'route'

  require('./Save/SaveLocation').SaveLocationController(option)

  app.get '/review', (req, res) ->
    res.render 'review'

  require('./Load/LoadLocation').LoadLocationController(option)

  app.get '/try', (req, res) ->
    res.render 'try'

  app.get '/log', (req, res) ->
    res.render 'log'

  require('./Inform/InformChild').InformChildController(option)

  # ------------------------------
  # 子供のルート
  # ------------------------------
  app.get '/children', (req, res) ->
    res.render 'children'

  require('./Arrive/InformArrive').InformArriveController(option)

  # ready msg ----------------------
  return "controller is setup"

