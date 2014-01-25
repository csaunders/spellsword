Character = {MAX_HP = 5, MAX_FOCUS = 5, SCALE=1}
Character.__index = Character

function Character.NewCharacter(x, y, name, scale)
  local self = setmetatable({}, Character)

  self.current_hp = Character.MAX_HP
  self.max_hp = Character.MAX_HP
  self.current_focus = Character.MAX_FOCUS
  self.max_focus = Character.MAX_FOCUS
  self.sprite = love.graphics.newImage("gfx/" .. name .. '.png')
  self.x = x
  self.y = y
  self.scale = scale or Character.SCALE
  self.width = self.scale * self.sprite:getWidth()
  self.height = self.scale * self.sprite:getHeight()

  return self
end

function Character:move(direction, x, y)
  if direction == "up" then
    y = y + self.height
  elseif direction == "down" then
    y = y - self.height
  elseif direction == "left" then
    x = x - self.width
  elseif direction == "right" then
    x = x + self.width
  end
  return x, y
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
