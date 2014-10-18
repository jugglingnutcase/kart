controllers = []

# Because the gamepad spec is polling-based not event-based :(
# rAF = window.requestAnimationFrame
updateTimer = 0

$(document).on 'keydown', (e) ->
  app.keydown e

$(window).on "gamepadconnected", (e) ->
  gp = e.originalEvent.gamepad
  console.log "%s: Gamepad connected at index %d: %s. %d buttons, %d axes.",
    new Date(), gp.index, gp.id, gp.buttons.length, gp.axes.length

  addgamepad gp

$(window).on "gamepaddisconnected", ->
  gp = e.originalEvent.gamepad
  controllers.remove[gp.index]
  # clearInterval(updateTimer)

addgamepad = (gamepad) ->
  controllers[gamepad.index] = gamepad

  # i'm using a timer instead of constantly calling rAF because rAF lets few other
  # events through for now. i'm sure there's a better way, but i'm not there yet
  updateTimer = setInterval(updateStatus, 1000)

  # Start polling the gamepad
  # rAF(updateStatus)

updateStatus = ->
  # we must scan the gamepads to get the updated values
  scangamepads()

  pads = (controller for own k, controller of controllers when k isnt undefined)
  buttons = pads.map (pad, padIndex) ->
    pad.buttons.map (button, buttonIndex) ->
      {button: button, index: buttonIndex, pad: padIndex}
  .reduce(Function.prototype.apply.bind(Array.prototype.concat))

  upButtonPressed = buttons.filter (button) ->
    button.index is 12
  .map (button) ->
    button.button.pressed
  .reduce Function.prototype.apply.bind(Array.prototype.concat)

  downButtonPressed = buttons.filter (button) ->
    button.index is 13
  .map (button) ->
    button.button.pressed
  .reduce Function.prototype.apply.bind(Array.prototype.concat)

  leftButtonPressed = buttons.filter (button) ->
    button.index is 14
  .map (button) ->
    button.button.pressed
  .reduce Function.prototype.apply.bind(Array.prototype.concat)

  rightButtonPressed = buttons.filter (button) ->
    button.index is 15
  .map (button) ->
    button.button.pressed
  .reduce Function.prototype.apply.bind(Array.prototype.concat)

  # Keep polling
  # rAF(updateStatus)

scangamepads = ->
  gamepads = navigator.getGamepads()

  # add any gamepads that aren't already discovered
  addgamepad gamepad for gamepad in gamepads when gamepad and gamepad.index not in controllers

  for gamepad in gamepads
    if gamepad and controllers[gamepad.index]
      controllers[gamepad.index] = gamepad
