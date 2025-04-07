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
    group = groups(:group_1)
    user = users(:admin_user)
    info = group.as_hash user
    assert info[:students].first[:login] == 'abcde'
    assert info[:has_demo_students] == false
    assert info[:owner] == true
  end
end
