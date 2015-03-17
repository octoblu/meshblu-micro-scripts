meshblu = require 'meshblu'
_       = require 'lodash'
meshbluJSON = require './meshblu.json'

class Deleter
  constructor: (@meshblu) ->
    @delay = 100

  start: =>
    @conn = @meshblu.createConnection meshbluJSON
    console.log 'starting...'
    @conn.on 'ready', =>
      console.log('ready');
      @getDevices (devices) =>
        _.pull devices, meshbluJSON.uuid
        _.each devices, (uuid) => 
          _.delay @claimAndRegister, @delay + 100, uuid

    @conn.on 'notReady', (error) =>
      console.log 'notready', error

  getDevices: (callback=->) =>
    console.log 'getting devices...'
    @conn.localdevices (result) =>
      console.log 'retrieved devices...' 
      callback _.pluck(result.devices, 'uuid')

  claimAndRegister: (uuid) => 
    @conn.claimdevice uuid: uuid, =>
      console.log 'claimed device ', uuid
      @conn.unregister uuid: uuid, (result) =>
        console.log 'unregister device ', uuid

deleter = new Deleter meshblu
deleter.start()



