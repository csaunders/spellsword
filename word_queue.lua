WordQueue = {DEFAULT_GRAB = 4}
WordQueue.__index = WordQueue

function WordQueue.NewQueue(dictionary_file)
  local self = setmetatable({}, WordQueue)

  self.words = self:extractWords(love.filesystem.newFile("dictionaries/" .. dictionary_file .. ".txt"))
  self.size = table.getn(self.words)

  return self
end

function WordQueue:grab(number)
  accumulator = {}
  for i = 1,(number or WordQueue.DEFAULT_GRAB) do
    index = math.random(self.size)
    table.insert(accumulator, self.words[index])
  end
  return accumulator
end

function WordQueue:extractWords(io)
  words = {}
  for line in io:lines() do
    table.insert(words, line)
  end
  return words
end
