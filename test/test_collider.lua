require "../collider"

local function setup(x, y)
  local testColliderObjects = {}
  local singleRect = {}
  singleRect['points'] = {
    {['x'] = 10, ['y'] = 10},
    {['x'] = 10, ['y'] = 15},
    {['x'] = 15, ['y'] = 15},
    {['x'] = 10, ['y'] = 15}
  }
  table.insert(testColliderObjects, singleRect)
  local testColliderCharacter = {
    ['x'] = x, ['y'] = y
  }
  return Collider.NewCollider(testColliderObjects), testColliderCharacter
end

function test_collision_inside_box()
  collider, character = setup(13, 13)
  assert_equal(true, collider:withinBounds(character))
end

function test_collision_outside_box()
  collider, character = setup(13, 17)
  assert_equal(false, collider:withinBounds(character))
end

function test_collision_on_line_of_box()
  collider, character = setup(13, 15)
  assert_equal(true, collider:withinBounds(character))
end
