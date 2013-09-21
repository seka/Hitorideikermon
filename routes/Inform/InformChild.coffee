exports.InformChildController = (option) ->
  app = option.app
  dataBase = option.database
  app.post '/inform/child_location', (req, res, next) ->
    informLocation = require '../../service/Inform/InformLocation'
    informLocation.main(req, res, dataBase)


