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
