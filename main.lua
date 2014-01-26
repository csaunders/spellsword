love.filesystem.load("tiledmap.lua")()
local lovetest = require("test/lovetest")
require("character")
require("word_queue")
require("keyboard_handler")
require("mode_switcher")
require("status")
require("cursor")
require("collider")
require("dungeon_master")

gKeyPressed = {}
gCamX,gCamY = 100,100
character = nil
words = nil
status = nil
modeSwitcher = nil
gameDebug = false
dungeonMaster = nil
collider = nil
-- otherwise the collisions for monsters get all fucked up
-- TODO: need to figure out WHY this is the way it is.
adjustmentX, adjustmentY = 0, 0

function love.load()
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  if lovetest.detect(arg) then lovetest.run() end

  local mapObjects = TiledMap_Load("maps/level0.tmx", 64)
  collider = Collider.NewCollider(mapObjects['Floor'])
  love.graphics.setNewFont('fonts/manaspace.regular.ttf', 14)
  startingPoint = mapObjects['Setup']['StartingPoint']
  gCamX = startingPoint['x']
  gCamY = startingPoint['y']
  adjustmentX = tonumber(startingPoint.properties.adjustX)
  adjustmentY = tonumber(startingPoint.properties.adjustY)
  character = Character.NewCharacter(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 'hero')
  status = Status.NewStatus(0, love.graphics.getHeight(), character)

  prepareHandlers()
  prepareDungeon(character, collider, gCamX, gCamY)
end

function love.keyreleased( key )
  gKeyPressed[key] = nil
end

function love.keypressed(key, unicode)
  gKeyPressed[key] = true
  if (key == "=") then modeSwitcher:reset() end
  if (key == "1" or key == "2" or key == "3" or key == "4") then return end
  if (key == "up" or key == "down" or key == "left" or key == "right") then
    dungeonMaster:tick(KeyboardHandler.SUCCESS, key)
    return
  end
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
  if response == KeyboardHandler.PROCESSING then return end

  if response == KeyboardHandler.SUCCESS then
    local updatedX, updatedY, success = character:move(handler():direction(), gCamX, gCamY, collider)
    success = success and dungeonMaster:updateMonsterPositions(gCamX-updatedX, gCamY-updatedY)
    if success then
      gCamX, gCamY = updatedX, updatedY
    else
      print("could not move that way!")
    end
  elseif response == KeyboardHandler.FAILURE and modeSwitcher:inflictsInjuries() then
    character:injure('focus')
  end
  modeSwitcher:reset()
  dungeonMaster:tick(response)
end

function prepareHandlers()
  words = WordQueue.NewQueue('basic_english')
  movementHandler = KeyboardHandler.NewHandler(words)
  statusHandler = KeyboardHandler.NewHandler(words)
  modeSwitcher = ModeSwitcher.NewModeSwitcher({movementHandler, statusHandler})
end

function prepareDungeon(character, collider, x, y)
  dungeonMaster = DungeonMaster.NewMaster(character, collider, x, y)
  dungeonMaster:spawnNewMonster()
end

function love.update(dt)
  local s = 100*dt
  if(gKeyPressed['1']) then adjustmentX = adjustmentX - s end
  if(gKeyPressed['2']) then adjustmentX = adjustmentX + s end
  if(gKeyPressed['3']) then adjustmentY = adjustmentY - s end
  if(gKeyPressed['4']) then adjustmentY = adjustmentY + s end
  -- if(gKeyPressed.up) then gCamY = gCamY - s end
  -- if(gKeyPressed.down) then gCamY = gCamY + s end
  -- if(gKeyPressed.left) then gCamX = gCamX - s end
  -- if(gKeyPressed.right) then gCamX = gCamX + s end
end

function love.draw()
  love.graphics.setBackgroundColor(0x80, 0x80, 0x80)
  TiledMap_DrawNearCam(gCamX, gCamY)
  --collider:draw(gCamX, gCamY)
  dungeonMaster:draw()
  character:draw()
  status:draw()
  handler():draw(status:center())
end
