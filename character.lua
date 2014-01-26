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

function Character:move(direction, x, y, collider)
  local dx, dy = x, y
  if direction == "up" then
    dy = y - self.height
  elseif direction == "down" then
    dy = y + self.height
  elseif direction == "left" then
    dx = x - self.width
  elseif direction == "right" then
    dx = x + self.width
  end
  if collider then
    local projx, projy = TiledMap_Project(dx, dy)
    local newPosition = {['x'] = dx, ['y'] = dy}
    if not collider:withinBounds(newPosition) then return x, y, false end
  end
  return dx, dy, true
end

function Character:injure(attribute)
  if attribute == "health" then
    self.current_hp = self.current_hp - 1
  elseif attribute == "focus" then
    self.current_focus = self.current_focus - 1
  end
end

function Character:draw()
  love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
end
