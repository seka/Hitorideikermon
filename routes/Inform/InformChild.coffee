exports.InformChildController = (option) ->
  app = option.app
  dataBase = option.database
  app.post '/dekiru/inform/child_location', (req, res, next) ->
    informLocation = require '../../service/Inform/InformLocation'
    informLocation.main(req, res, dataBase)


