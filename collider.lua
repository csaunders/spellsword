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
    local points = bound['points']
    local size = table.getn(points)
    for i=1,size do
      local A, B, C, D = nil, nil, nil, nil
      local formatString = "(%d, %d) -- Comparing p1(%d, %d) to p2(%d, %d)"
      local p1 = points[i % (size + 1)]
      local p2 = points[(i + 1) % (size)]
      p2 = p2 or points[1]
      print(string.format(formatString, character.x, character.y, p1.x, p1.y, p2.x, p2.y))
      A = -(p2.y - p1.y)
      B = p2.x - p1.x
      C = -(A*p1.x + B*p1.y)
      D = A * character.x + B * character.y + C

      -- if character.y == 15 then
        print(string.format("A %d, B %d, C %d, D %d", A, B, C, D))
      --   print(os)
      --   local formatString = "%s (%d, %d)"
      --   print(string.format(formatString, 'Character', character.x, character.y))
      --   print(string.format(formatString, 'p1', p1.x, p1.y))
      --   print(string.format(formatString, 'p2', p2.x, p2.y))
      -- end

      if D < 0 then
        self:cacheBoundCheck(character)
        within = false
        break
      end
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
