exports.LoadLocationController = (option) ->
  app = option.app
  dataBase = option.database
  app.post '/load/location', (req, res, next) ->
    saveLocation = require '../../service/Load/LoadLocation'
    saveLocation.main(req, res, dataBase)

