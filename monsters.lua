require('character')
Monsters = {}

function Monsters.gooBall(x, y)
  goo = Character.NewCharacter(x, y, 'gooball')
  goo:setHp(1, 1)
  goo:setFocus(0, 0)
  return goo
end
