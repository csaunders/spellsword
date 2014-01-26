require('renderer')

SplashRenderer = inheritsFrom( Renderer )
SplashRenderer.__index = SplashRenderer

function SplashRenderer.NewSplash(klass, title)
  local self = SplashRenderer:create()

  self.renderItems = {}
  self:addBackground()
  self:addTitle(title)

  return self
end

function SplashRenderer:renderItems()
  return self.drawables
end

function SplashRenderer:addRenderItem(d)
  table.insert(self.renderItems, d)
end

function SplashRenderer:addBackground()
  local image = love.graphics.newImage('gfx/splash/frank_face.png')
  local draw  = RenderItem:NewRenderItem(image, 0, 0)
  self:addRenderItem(draw)
end

function SplashRenderer:addTitle(title)
  local width, height = love.graphics.getWidth(), love.graphics.getHeight() / 4
  local canvas = love.graphics.newCanvas(width, height)
  local currentFont = love.graphics.getFont()
  love.graphics.setCanvas(canvas)

  -- Draw to local canvas code
  local font = love.graphics.newFont('fonts/manaspace.regular.ttf', 50)
  love.graphics.setFont(font)
  love.graphics.setColor(0x5C,0x5C,0x5C)
  local fontWidth, fontHeight = font:getWidth(title), font:getHeight(title)
  love.graphics.print(title, (width - fontWidth)/2, (height - fontHeight)/2)
  -- /Draw to local canvas code

  if currentFont then love.graphics.setFont(currentFont) end
  love.graphics.reset()
  love.graphics.setCanvas()
  local draw = RenderItem:NewRenderItem(canvas, 0, love.graphics.getHeight() - canvas:getHeight())
  self:addRenderItem(draw)
end
