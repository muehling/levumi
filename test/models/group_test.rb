require 'test_helper'
#require 'minitest/autorun'

class GroupTest < ActionDispatch::IntegrationTest
  test 'Group.owner' do
    owner = groups(:group_1).owner
    assert_equal owner.id, 1
  end

  test 'Group.read_only with read access' do
    group = groups(:group_1)
    user = users(:admin_user)

    assert (group.read_only(user) == false)
  end

  test 'Group.read_only with write access' do
    group = groups(:group_1)
    user = users(:other_user)
    assert (group.read_only(user) == false)
  end
end
