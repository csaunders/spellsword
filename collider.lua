Collider = {}
Collider.__index = Collider

function Collider.NewCollider(objects)
  local self = setmetatable({}, Collider)
  self.objects = {}
  self.colors = {}
  self.outsideBounds = {}
  
  for i, obj in ipairs(objects) do self:addObject(obj) end

  return self
end

function Collider:cacheBoundCheck(character)
  self.outsideBounds[self:cacheKey(character)] = true
end

function Collider:addObject(object)
  table.insert(self.colors, {math.random(255), math.random(255), math.random(255)})
  table.insert(self.objects, object)
end

function Collider:cacheKey(character)
  return character.x .. 'x' .. character.y
end

function Collider:knownPointWithinBounds(character)
  return self.outsideBounds[self:cacheKey(character)]
end

function Collider:performBoundsCheck(character)
  local within = false
  for i, bound in ipairs(self.objects) do
    local normalizedX = character.x - (bound.x + character.adjustmentX)
    local normalizedY = character.y - (bound.y + character.adjustmentY)

    if normalizedX >= 0 and normalizedY >= 0 and normalizedX <= bound.width and normalizedY <= bound.height then
      self:cacheBoundCheck(character)
      within = true
      break
    end
  end
  return within
end

function Collider:withinBounds(character)
  --if self:knownPointWithinBounds(character) then
  --  return true
  --else
    local withinBounds = self:performBoundsCheck(character)
    if withinBounds then self:cacheBoundCheck(character) end
    return withinBounds
  --end
end

function Collider:draw(x, y)
  for i, bound in ipairs(self.objects) do
    love.graphics.setColor(self.colors[i])
    love.graphics.rectangle('line', bound.x + adjustmentX, bound.y + adjustmentY, bound.width, bound.height)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print('('..adjustmentX..','..adjustmentY..')', 50, 50)
  end
  love.graphics.reset()
end
