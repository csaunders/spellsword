KeyboardHandler = {
  PUP = 1,
  PDOWN = 2,
  PLEFT = 3,
  PRIGHT = 4,
  SUCCESS = 5,
  FAILURE = 6,
  PROCESSING = 7,
  ARROW = love.graphics.newImage('gfx/arrow_up.png'),
  ONLYDRAW = 4
}

KeyboardHandler.__index = KeyboardHandler

function KeyboardHandler.NewHandler(dictionary, words)
  if gameDebug then
    KeyboardHandler.ARROW = love.graphics.newImage('gfx/arrow_up_dbg.png')
  end

  local self = setmetatable({}, KeyboardHandler)
  self.status = KeyboardHandler.PROCESSING
  self.dictionary = dictionary
  self:setWords(words or dictionary:grab())

  return self
end

function KeyboardHandler:reset()
  self:setWords(self.dictionary:grab())
end

function KeyboardHandler:setWords(words)
  self.wordStrings = words
  self.staticWords = {}
  self.words = {}
  self.chosenWord = nil
  for i = 1,table.getn(words) do
    word = {}
    staticWord = {}
    for c in words[i]:gmatch(".") do
      table.insert(word, c)
      table.insert(staticWord, c)
    end
    table.insert(self.words, word)
    table.insert(self.staticWords, staticWord)
  end
end

function KeyboardHandler:chosenDirection()
  return self.chosenWord
end

function KeyboardHandler:getWord(position)
  return self.staticWords[postion]
end

function KeyboardHandler:handle(key)
  if self.chosenWord == nil then
    for i=1,table.getn(self.words) do
      if self.words[i][1] == key then
        self.chosenWord = i
      end
    end
  end
  self.status = self:handleChosenWord(key)
  return self.status
end

function KeyboardHandler:handleChosenWord(key)
  if self.chosenWord == nil then
    return KeyboardHandler.FAILURE
  end

  word = self.words[self.chosenWord]

  if word[1] == key then
    table.remove(word, 1)
  else
    return KeyboardHandler.FAILURE
  end

  if table.getn(word) == 0 then
    return KeyboardHandler.SUCCESS
  else
    return KeyboardHandler.PROCESSING
  end
end

function KeyboardHandler:direction()
  d = self.chosenWord
  dw = nil
  if d == KeyboardHandler.PUP then
    dw = "up"
  elseif d == KeyboardHandler.PDOWN then
    dw = "down"
  elseif d == KeyboardHandler.PLEFT then
    dw = "left"
  elseif d == KeyboardHandler.PRIGHT then
    dw = "right"
  end
  return dw
end

function KeyboardHandler:draw(cursor)
  image = KeyboardHandler.ARROW
  setFontSize(22)

  local width, height = image:getWidth(), image:getHeight()
  for i=1,table.getn(self.words) do
    if gameDebug and i ~= KeyboardHandler.ONLYDRAW then
      -- do nothing
    else
      cursor:reset()
      if i == KeyboardHandler.PUP then
        cursor:moveBy(0, -height/2)
        drawImage(cursor, image, 0)
        cursor:moveBy(0, -height/2)
      elseif i == KeyboardHandler.PDOWN then
        cursor:moveBy(0, height/2)
        drawImage(cursor, image, 3.14159)
        cursor:moveBy(0, height/2)
      elseif i == KeyboardHandler.PLEFT then
        cursor:moveBy(-width/2, 0)
        drawImage(cursor, image, 3.14149 * 1.5)
        cursor:moveBy(-width/2, 0)
      else
        cursor:moveBy(width/2, 0)
        drawImage(cursor, image, 3.14159 / 2)
        cursor:moveBy(width/2, 0)
      end
      self:drawWord(cursor, i)
      -- cursor:draw()
    end
  end
  cursor:reset()
  cursor:draw({0xFF, 0, 0})
end

function KeyboardHandler:drawWord(cursor, i)
  local word = self.wordStrings[i]
  local font = love.graphics.getFont()
  local static = self.staticWords[i]
  local actual = self.words[i]
  local width = font:getWidth(word)
  local height = font:getHeight(word)
  local sidx, idx = 1, 1
  while static[sidx] ~= actual[idx] do
    sidx = sidx + 1
  end
  self:compensateForLocation(word, cursor, i, font)
  cursor:moveBy(-width/2, -height/2)
  if sidx ~= idx then
    love.graphics.setColor(0xFF, 0, 0)
    message = string.sub(word, 1, sidx - 1)
    love.graphics.print(message, cursor.x, cursor.y)
    cursor:moveBy(font:getWidth(message), 0)
  end
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  message = string.sub(word, sidx)
  love.graphics.print(message, cursor.x, cursor.y)
  love.graphics.reset()
end

function KeyboardHandler:compensateForLocation(word, cursor, i, font)
  if i == KeyboardHandler.PUP then
    cursor:moveBy(0, -5)
  elseif i == KeyboardHandler.PDOWN then
    cursor:moveBy(0, 5)
  elseif i == KeyboardHandler.PLEFT then
    cursor:moveBy(-font:getWidth(word)/2,0)
  else
    cursor:moveBy(font:getWidth(word)/2, 0)
  end
end
