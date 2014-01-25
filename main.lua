love.filesystem.load("tiledmap.lua")()
require("character")
require("word_queue")
require("keyboard_handler")
require("mode_switcher")
require("status")
require("cursor")

gKeyPressed = {}
gCamX,gCamY = 100,100
character = nil
words = nil
status = nil
modeSwitcher = nil
gameDebug = false

function love.load()
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  TiledMap_Load("maps/basic.tmx", 16)
  love.graphics.setNewFont('fonts/manaspace.regular.ttf', 14)
  character = Character.NewCharacter(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 'hero')
  status = Status.NewStatus(0, love.graphics.getHeight(), character)

  prepareHandlers()
end

function love.keyreleased( key )
  gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
  gKeyPressed[key] = true
  if (key == "escape") then os.exit(0) end
  if (key == "=") then modeSwitcher:reset() end
  response = modeSwitcher:handle(key)
  if response == KeyboardHandler.PROCESSING then
    return
  else
    tick(response)
  end
end

function drawImage(cursor, image, rads)
  width, height = image:getWidth() / 2, image:getHeight() / 2
  multX, multY = 1, 1
  if rads == 3.14159 then -- rotated 180deg
    -- nothing to
  elseif rads > 3.14159 and rads < 2*3.14159 then -- rotated 270deg
    multX = -1
  elseif rads > 0 and rads < 3.14159 then -- rotated 90deg
    multX = 1
    multY = -1
  else -- rotated 0deg
    multX = -1
    multY = -1
  end

  love.graphics.draw(image, cursor.x + (multX*width), cursor.y + (multY*height), rads)
  if gameDebug then cursor:draw() end
end

function setFontSize(size)
  love.graphics.setNewFont('fonts/manaspace.regular.ttf', size or 14)
end

function handler()
  return modeSwitcher:handler()
end

function tick(response)
  if response == KeyboardHandler.SUCCESS then
    gCamX, gCamY = character:move(handler():direction(), gCamX, gCamY)
    modeSwitcher:reset()
  elseif response == KeyboardHandler.FAILURE then
    character:injure('focus')
    modeSwitcher:reset()
  end
end

function prepareHandlers()
  words = WordQueue.NewQueue('basic_english')
  movementHandler = KeyboardHandler.NewHandler(words)
  statusHandler = KeyboardHandler.NewHandler(words)
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
  character:draw()
  status:draw()
  cursor = Cursor.NewCursor(status:center())
  handler():draw(cursor)
end
