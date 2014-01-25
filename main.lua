love.filesystem.load("tiledmap.lua")()
require("character")
require("word_queue")
require("keyboard_handler")
require("mode_switcher")

gKeyPressed = {}
gCamX,gCamY = 100,100
character = nil
words = nil
handler = nil
modeSwitcher = nil

function love.load()
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  TiledMap_Load("maps/basic.tmx", 16)
  love.graphics.setNewFont('fonts/manaspace.regular.ttf', 14)
  character = Character.NewCharacter(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 'hero')
  prepareHandlers()
end

function love.keyreleased( key )
  gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
  gKeyPressed[key] = true
  if (key == "escape") then os.exit(0) end
  if (key == "=") then handler:setWords(words:grab()) end
  response = modeSwitcher:handle(key)
  if response == KeyboardHandler.PROCESSING then
    return
  else
    tick(response)
  end
end

function handler()
  return modeSwitcher:handler()
end

function tick(response)
  if response == KeyboardHandler.SUCCESS then
    gCamX, gCamY = character:move(handler():direction(), gCamX, gCamY)
    handler():setWords(words:grab())
  elseif response == KeyboardHandler.FAILURE then
    character.injure('focus')
    handler():setWords(words:grab())
  end
end

function prepareHandlers()
  words = WordQueue.NewQueue('basic_english')
  movementHandler = KeyboardHandler.NewHandler(words:grab())
  statusHandler = KeyboardHandler.NewHandler(words:grab())
  modeSwitcher = ModeSwitcher.NewModeSwitcher({movementHandler, statusHandler})
end

function love.update(dt)
  local s = 500*dt
  if(gKeyPressed.up) then gCamY = gCamY - s end
  if(gKeyPressed.down) then gCamY = gCamY + s end
  if(gKeyPressed.left) then gCamX = gCamX - s end
  if(gKeyPressed.right) then gCamX = gCamX + s end
end

function love.draw()
  love.graphics.setBackgroundColor(0x80, 0x80, 0x80)
  TiledMap_DrawNearCam(gCamX, gCamY)
  love.graphics.print('(' .. gCamX .. ',' .. gCamY .. ')', 50, 50)
  handler():draw(character)
  character:draw()
end
