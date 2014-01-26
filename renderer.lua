require('inheritance')
Renderer = {}
Renderer.__index = Renderer

RenderItem = {}
RenderItem.__index = RenderItem

function RenderItem.NewRenderItem(klass, image, x, y)
  local self = setmetatable({}, RenderItem)
  self.d = image
  self.x = x
  self.y = y

  return self
end

 function Renderer:create()
   local self = setmetatable({}, Renderer)
   self.renderItems = {}

   return self
 end

function Renderer:draw()
  for i, renderItem in ipairs(self.renderItems) do
    love.graphics.draw(renderItem.d, renderItem.x, renderItem.y)
  end
end


