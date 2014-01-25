Cursor = {}
Cursor.__index = Cursor

function Cursor.NewCursor(x, y)
  local self = setmetatable({}, Cursor)

  self.startX = x
  self.startY = y
  self.x = x
  self.y = y

  return self
end

function Cursor:reset()
  self.x = self.startX
  self.y = self.startY
end

function Cursor:moveBy(x, y)
  self.x = self.x + x
  self.y = self.y + y
end

function Cursor:draw(color)
  love.graphics.setColor(color or {0xFF, 0xFF, 0})
  love.graphics.circle('fill', self.x, self.y, 5)
  love.graphics.reset()
end
