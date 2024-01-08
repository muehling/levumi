require 'test_helper'

class GroupTest < ActionDispatch::IntegrationTest
  test 'Group.owner' do
    owner = groups(:group_1).owner
    assert_equal owner.id, 1
  end

  test 'Group.read_only with read access' do
    share = group_shares(:share_2)
    share.update!(read_only: true)

    user = users(:admin_user)
    group = groups(:group_2)

    assert (group.read_only(user) == true)
  end

  test 'Group.read_only with write access' do
    group = groups(:group_1)
    user = users(:admin_user)
    share = group_shares(:share_2)

    assert (group.read_only(user) == false)
  end

  test 'Group.as_hash' do
    #TODO
  end
end
