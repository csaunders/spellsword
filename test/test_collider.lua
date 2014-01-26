require "../collider"

local function setup(x, y)
  local testColliderObjects = {}
  local singleRect = {['x'] = 10, ['y'] = 10, ['width'] = 5, ['height'] = 5}
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

function test_point_caching()
  collider, character = setup(17, 13)
  assert_equal(false, collider:withinBounds(character))
  assert_equal(true, collider:knownPointOutOfBounds(character))
end
