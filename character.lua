Character = {MAX_HP = 5, MAX_FOCUS = 5, SCALE=1, COUNTER=0}
Character.__index = Character

function Character.NewCharacter(x, y, name, scale)
  local self = setmetatable({}, Character)

  self.current_hp = Character.MAX_HP
  self.max_hp = Character.MAX_HP
  self.current_focus = Character.MAX_FOCUS
  self.max_focus = Character.MAX_FOCUS
  self.sprite = love.graphics.newImage("gfx/" .. name .. '.png')
  self.injurySound = love.audio.newSource("audio/fx/" .. name .. "injure.ogg", 'static')
  self.deathSound = love.audio.newSource("audio/fx/" .. name .. "die.ogg", 'static')
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
  self.current_focus = current or self.current_focus
  self.max_focus = max or self.max_focus
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

function Character:injuredHp()
  return self.current_hp < self.max_hp
end

function Character:injuredFocus()
  return self.current_focus < self.max_focus
end

function Character:injured()
  return self:injuredHp() or self:injuredFocus()
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
    if self:dead() then
      self.deathSound:play()
    else
      self.injurySound:play()
    end
  elseif attribute == "focus" then
    self.current_focus = self.current_focus - 1
  end
end

function Character:heal(attribute, amount)
  amount = amount or 1
  if attribute == "health" then
    self.current_hp = self.current_hp + amount
  elseif attribute == "focus" then
    self.current_focus = self.current_focus + amount
  end
  self:correctDiscrepancies()
end

function Character:healRandom(amount)
  attrs = {}
  if self:injuredHp() then table.insert(attrs, 'health') end
  if self:injuredFocus() then table.insert(attrs, 'focus') end
  attribute = attrs[math.random(table.getn(attrs))]
  self:heal(attribute, amount)
end

function Character:center()
  return (self.drawX or self.x) + self.height/2, (self.drawY or self.y) + self.width/2
end

function Character:radius()
  if self.height > self.width then
    return self.height * self.height
  else
    return self.width * self.height
  end
end

function Character:attack(other)
  other:injure('health')
end

function Character:isBeside(other)
  local cx, cy = self:center()
  local ocx, ocy = other:center()
  local a = math.abs(ocy - cy)
  local b  = math.abs(ocx - cx)
  local radius = (a * a) + (b * b)
  local delta = (3.14159*2*self:radius()) - (3.14159*2*radius)
  return delta > 0
end

function Character:draw()
  love.graphics.draw(self.sprite, self.drawX, self.drawY, 0, self.scale, self.scale)
  -- love.graphics.circle('fill', self.drawX, self.drawY, 2)
  -- local cx, cy = self:center()
  -- love.graphics.circle('fill', cx, cy, 2)
end
