Character = {MAX_HP = 100, MAX_FOCUS = 50, SCALE=1}
Character.__index = Character

function Character.NewCharacter(x, y, name, scale)
  local self = setmetatable({}, Character)

  self.hp = Character.MAX_HP
  self.focus = Character.MAX_FOCUS
  self.sprite = love.graphics.newImage("gfx/" .. name .. '.png')
  self.x = x
  self.y = y
  self.scale = scale or Character.SCALE
  self.width = self.scale * self.sprite:getWidth()
  self.height = self.scale * self.sprite:getHeight()

  return self
end

function Character:move(direction)
  if direction == "up" then
    self.y = self.y - self.height
  elseif direction == "down" then
    self.y = self.y + self.height
  elseif direction == "left" then
    self.x = self.x - self.width
  elseif direction == "right" then
    self.x = self.x + self.width
  end    
end

function Character:injure(attribute, amount)
  amount = amount or math.random(10)
  if attribute == "health" then
    self.hp = self.hp - amount
  elseif attribute == "focus" then
    self.focus = self.focus - amount
  end
end

function Character:draw()
  love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
end
