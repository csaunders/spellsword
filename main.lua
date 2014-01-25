love.filesystem.load("tiledmap.lua")()
require("character")
require("word_queue")
require("keyboard_handler")

gKeyPressed = {}
gCamX,gCamY = 100,100
character = nil
words = nil
handler = nil

function love.load()
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  TiledMap_Load("maps/basic.tmx", 16)
  love.graphics.setNewFont('fonts/manaspace.regular.ttf', 14)
  character = Character.NewCharacter(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 'hero')
  words = WordQueue.NewQueue('basic_english')
  handler = KeyboardHandler.NewHandler(words:grab())
end

function love.keyreleased( key )
  gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
  gKeyPressed[key] = true
  if (key == "escape") then os.exit(0) end
  if (key == "=") then handler:setWords(words:grab()) end
  response = handler:handle(key)
  if response == KeyboardHandler.SUCCESS then
    character.move(handler:direction())
    handler:setWords(words:grab())
  elseif response == KeyboardHandler.FAILURE then
    character.injure('focus')
    handler:setWords(words:grab())
  end
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
  handler:draw(character)
  character:draw()
end
