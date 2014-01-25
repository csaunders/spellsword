require("cursor")

Status = {
  PADDING_X = 46,
  PADDING_Y = 46,
  FULLHP = love.graphics.newImage('gfx/full_heart.png'),
  MISSHP = love.graphics.newImage('gfx/empty_heart.png'),
  FULLFOC = love.graphics.newImage('gfx/focus_full.png'),
  MISSFOC = love.graphics.newImage('gfx/focus_empty.png')
}
Status.__index = Status

function Status.NewStatus(x, y, character)
  local self = setmetatable({}, Status)
  self.background = love.graphics.newImage("gfx/statusbox.png")
  self.x = x
  self.y = y - self.background:getHeight()
  self.cursor = Cursor.NewCursor(self.x + Status.PADDING_X, self.y + Status.PADDING_Y)
  self.character = character

  return self
end

function Status:center()
  self.center_x = self.center_x or (self.x + (self.background:getWidth() / 2))
  self.center_y = self.center_y or (self.y + (self.background:getHeight() / 2))
  return self.center_x, self.center_y
end

function Status:draw()
  love.graphics.draw(self.background, self.x, self.y)
  self:drawHealth(self.cursor)
  self:drawFocus(self.cursor)
  love.graphics.reset()
end

function Status:drawHealth(cursor)
  cursor:reset()
  width, height = Status.FULLHP:getWidth(), Status.FULLHP:getHeight()
  for i=1,self.character.max_hp do
    if i <= self.character.current_hp then
      image = Status.FULLHP
    else
      image = Status.MISSHP
    end
    love.graphics.draw(image, cursor.x, cursor.y)
    cursor:moveBy(width, 0)
  end
end

function Status:drawFocus(cursor)
  cursor:reset()
  width, height = Status.FULLFOC:getWidth(), Status.FULLFOC:getHeight()
  cursor:moveBy(self.background:getWidth() - Status.PADDING_X*3, 0)
  for i=1,self.character.max_focus do
    if i <= self.character.current_focus then
      image = Status.FULLFOC
    else
      image = Status.MISSFOC
    end
    love.graphics.draw(image, cursor.x, cursor.y)
    cursor:moveBy(-width, 0)
  end
end
