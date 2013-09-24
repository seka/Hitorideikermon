exports.SaveLocationController = (option) ->
  app = option.app
  dataBase = option.database
  app.post '/dekiru/save/location', (req, res, next) ->
    saveLocation = require '../../service/Save/SaveLocation'
    saveLocation.main(req, res, dataBase)


