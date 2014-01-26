Character = {MAX_HP = 5, MAX_FOCUS = 5, SCALE=1, COUNTER=0}
Character.__index = Character

function Character.NewCharacter(x, y, name, scale)
  local self = setmetatable({}, Character)

  self.current_hp = Character.MAX_HP
  self.max_hp = Character.MAX_HP
  self.current_focus = Character.MAX_FOCUS
  self.max_focus = Character.MAX_FOCUS
  self.sprite = love.graphics.newImage("gfx/" .. name .. '.png')
  self:setPosition(x, y)
  self:setDrawPosition(x, y)
  self.adjustmentX = 0
  self.adjustmentY = 0
  self.scale = scale or Character.SCALE
  self.width = self.scale * self.sprite:getWidth()
  self.height = self.scale * self.sprite:getHeight()
  self.name = name .. Character.COUNTER
  Character.COUNTER = Character.COUNTER + 1

  return self
end

function Character:setHp(current, max)
  self.current_hp = current or self.current_hp
  self.max_hp = max or self.max_hp
  self:correctDiscrepancies()
end

function Character:setFocus(current, max)
  self.current_hp = current or self.current_hp
  self.max_hp = max or self.max_hp
  self:correctDiscrepancies()
end

function Character:correctDiscrepancies()
  if self.current_hp > self.max_hp then
    self.current_hp = self.max_hp
  end
  if self.current_focus > self.max_focus then
    self.current_focus = self.max_focus
  end
end

function Character:unfocused()
  return self.current_focus <= 0
end

function Character:dead()
  return self.current_hp <= 0
end

function Character:move(direction, x, y, collider)
  local dx, dy = x or self.x, y or self.y
  if direction == "up" then
    dy = dy - self.height
  elseif direction == "down" then
    dy = dy + self.height
  elseif direction == "left" then
    dx = dx - self.width
  elseif direction == "right" then
    dx = dx + self.width
  end
  if collider then
    local newPosition = {
      ['x'] = dx, ['y'] = dy,
      ['name'] = self.name,
      ['adjustmentX'] = self.adjustmentX or 0,
      ['adjustmentY'] = self.adjustmentY or 0
    }
    if not collider:withinBounds(newPosition) then return x, y, false end
  end
  return dx, dy, true
end

function Character:setPosition(x, y)
  local oldX, oldY = (self.x or x), (self.y or y)
  self:applyDelta(x-oldX, y - oldY)
  self.x, self.y = x, y
end

function Character:setDrawPosition(x, y)
  self.drawX, self.drawY = x, y
end

function Character:applyDelta(dx, dy)
  self.drawX = (self.drawX or 0) + (dx or 0)
  self.drawY = (self.drawY or 0) + (dy or 0)
end

function Character:injure(attribute)
  if attribute == "health" then
    self.current_hp = self.current_hp - 1
  elseif attribute == "focus" then
    self.current_focus = self.current_focus - 1
  end
end

function Character:draw()
  love.graphics.draw(self.sprite, self.drawX, self.drawY, 0, self.scale, self.scale)
  love.graphics.circle('fill', self.drawX, self.drawY, 2)
end
