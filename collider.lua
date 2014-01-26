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

function Collider:cacheKey(character)
  return character.x .. 'x' .. character.y
end

function Collider:knownPointOutOfBounds(character)
  return self.outsideBounds[self:cacheKey(character)]
end

function Collider:performBoundsCheck(character)
  local within = true
  for i, bound in ipairs(self.objects) do
    local normalizedX = character.x - bound.x
    local normalizedY = character.y - bound.y

    if normalizedX > bound.width or normalizedY > bound.height then
      self:cacheBoundCheck(character)
      within = false
      break
    end
  end
  return within
end

function Collider:withinBounds(character)
  if self:knownPointOutOfBounds(character) then
    return false
  else
    local withinBounds = self:performBoundsCheck(character)
    if not withinBounds then self:cacheBoundCheck(character) end
    return withinBounds
  end
end
