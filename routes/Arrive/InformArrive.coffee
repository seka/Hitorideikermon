exports.InformArriveController = (option) ->
  app = option.app
  dataBase = option.database
  app.post '/inform/arrive_child', (req, res, next) ->
    informArrive = require '../../service/Inform/InformArrive'
    informArrive.main(req, res, dataBase)


