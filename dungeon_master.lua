require('monsters')
require('keyboard_handler')
DungeonMaster = {SPRITE_SIZE = 64, DIRECTIONS = {'up', 'down', 'left', 'right'}}
DungeonMaster.__index = DungeonMaster

function DungeonMaster.NewMaster(character, collider, x, y)
  local self = setmetatable({}, DungeonMaster)

  self.monsters = {}
  self.character = character
  self.collider = collider
  self.x = x
  self.y = y

  return self
end

function DungeonMaster:spawnNewMonster()
  if table.getn(self.monsters) < 3 then
    while true do
      local xMult = self:genMult()
      local yMult = self:genMult()
      local deltaX = math.random(5) * 64
      local deltaY = math.random(5) * 64
      local startX = self.x + xMult*deltaX
      local startY = self.y + yMult*deltaY
      local monster = Monsters.gooBall(startX, startY)
      monster.adjustmentX = adjustmentX
      monster.adjustmentY = adjustmentY
      if self.collider:withinBounds(monster) then
        self:addMonster(monster)
        return
      end
    end
  end
end

function DungeonMaster:addMonster(monster)
  table.insert(self.monsters, monster)
end

function DungeonMaster:updateMonsterPositions(dx, dy)
  updater = function(monster)
    monster:applyDelta(dx, dy)
  end
  self:monsterProcess(updater)
end

function DungeonMaster:genMult()
  if math.random(2) == 2 then return 1 else return -1 end
end

function DungeonMaster:tick(response, direction)
  if Response == KeyboardHandler.PROCESSING then return end
  mover = function(monster)
    local x, y = monster:move(direction or self:determineDirection(), monster.x, monster.y, self.collider)
    monster:setPosition(x, y)
  end
  self:monsterProcess(mover)
end

function DungeonMaster:draw()
  drawer = function(monster)
    monster:draw()
  end
  self:monsterProcess(drawer)
end

function DungeonMaster:monsterProcess(f)
  for i, monster in ipairs(self.monsters) do
    f(monster)
  end
end

function DungeonMaster:determineDirection()
  local index = math.random(table.getn(DungeonMaster.DIRECTIONS))
  local direction = DungeonMaster.DIRECTIONS[index]
  return direction
end
