_ = require 'underscore'
Spine._ = require 'underscore'

fsUtils = require '../lib/fs-utils'
path = require 'path'

class GameConsole extends Spine.Model
  @configure "GameConsole", "name", "prefix", "extensions"

  constructor: ->
    super
    @games = []
    @settings = new App.Settings
    @loadGames()
    @defaultArtPath = path.join(__dirname, '..', '..', 'images', 'default-art', 'game-consoles', @prefix)

  path: ->
    path.join(@settings.romsPath(), @prefix)

  romPaths: ->
    fsUtils.listSync(@path(), @extensions)

  imagePath: ->
    path.join(@path(), 'image.png')

  gameCardPath: ->
    path.join(@defaultArtPath, 'gameCard.png')

  imageExists: ->
    fsUtils.exists(@imagePath())

  loadGames: ->
    gameConsole = @
    @games = _.map @romPaths(), (path) ->
      new App.Game(filePath: path, gameConsole: gameConsole)

module.exports = GameConsole
