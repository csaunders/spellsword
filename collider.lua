Collider = {}
Collider.__index = Collider

function Collider.NewCollider(objects)
  local self = setmetatable({}, Collider)
  self.objects = objects
  self.outsideBounds = {}

  return self
end

function Collider:cacheBoundCheck(character)
  self.outsideBounds[self:cacheKey(character)] = true
end

function Collider:addObject(object)
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
    local normalizedX = character.x - bound.x
    local normalizedY = character.y - bound.y

    if normalizedX >= 0 and normalizedY >= 0 and normalizedX <= bound.width and normalizedY <= bound.height then
      self:cacheBoundCheck(character)
      within = true
      break
    end
  end
  return within
end

function Collider:withinBounds(character)
  if self:knownPointWithinBounds(character) then
    return true
  else
    local withinBounds = self:performBoundsCheck(character)
    if withinBounds then self:cacheBoundCheck(character) end
    return withinBounds
  end
end
