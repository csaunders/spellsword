KeyboardHandler = {
  PUP = 1,
  PDOWN = 2,
  PLEFT = 3,
  PRIGHT = 4,
  SUCCESS = 5,
  FAILURE = 6,
  PROCESSING = 7
  ARROW = love.graphics.newImage('gfx/arrow_up.png')
}
KeyboardHandler.__index = KeyboardHandler

function KeyboardHandler.NewHandler(dictionary, words)
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
  if self.chosenWord then
    self:drawWord(cursor, self.chosenWord)
  else
    for i=1,table.getn(self.words) do
      cursor:reset()
      local xoff, yoff = 0, 0
      if i == KeyboardHandler.PUP then
        yoff = 16
      elseif i == KeyboardHandler.PDOWN then
        yoff = -16
      elseif i == KeyboardHandler.PLEFT then
        xoff = -46
      else
        xoff = 46
      end
      cursor:moveBy(xoff, yoff)
      self:drawWord(cursor, i)
    end
  end
end

function KeyboardHandler:drawWord(cursor, i)
  word = self.wordStrings[i]
  font = love.graphics.getFont()
  static = self.staticWords[i]
  actual = self.words[i]
  width = font:getWidth(word)
  height = font:getHeight(word)
  sidx, idx = 1, 1
  while static[sidx] ~= actual[idx] do
    sidx = sidx + 1
  end
  drawPosition = cursor.x - (width / 2)
  if sidx ~= idx then
    love.graphics.setColor(0xFF, 0, 0)
    message = string.sub(word, 1, sidx - 1)
    love.graphics.print(message, drawPosition, cursor.y)
    drawPosition = drawPosition + font:getWidth(message)
  end
  love.graphics.setColor(0xFF, 0xFF, 0xFF)
  message = string.sub(word, sidx)
  love.graphics.print(message, drawPosition, cursor.y)
  love.graphics.reset()
end
