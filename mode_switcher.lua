ModeSwitcher = {}
ModeSwitcher.__index = ModeSwitcher

function ModeSwitcher.NewModeSwitcher(handlers)
  local self = setmetatable({}, ModeSwitcher)
  self.modes = {}
  for i, handler in ipairs(handlers) do
    self:insertHandler(handler)
  end
  
  return self
end

function ModeSwitcher:insertHandler(handler)
  table.insert(self.modes, handler)
end

function ModeSwitcher:handle(key)
  if key == " " then
    return self:nextMode()
  else
    return self:handler():handle(key)
  end
end

function ModeSwitcher:getMode()
  return self:handler():name()
end

function ModeSwitcher:handler()
  return self.modes[1]
end

function ModeSwitcher:tick(response)
end

function ModeSwitcher:reset()
  self:handler():reset()
end

function ModeSwitcher:nextMode()
  previousMode = table.remove(self.modes, 1)
  table.insert(self.modes, previousMode)
end
