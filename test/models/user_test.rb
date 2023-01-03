require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest
  test 'User.students' do
    user = users(:admin_user)
    assert (user.students.length == 3)
  end

  test 'User.has_capability "test" as admin' do
    user = users(:admin_user)
    assert (user.has_capability?('test') == true)
  end

  test 'User.has_capability "test" as non-admin with no capability' do
    user = users(:other_user)
    assert (user.has_capability?('test') == false)
  end

  test 'User.has_capability "test" as non-admin with test capability' do
    user = users(:other_user)
    user.update!(capabilities: 'test')
    assert (user.has_capability?('test') == true)
  end

  test 'User.is_regular_user as admin' do
    user = users(:admin_user)
    assert (user.is_regular_user? == false)
  end

  test 'User.is_regular_user as user without capabilities' do
    user = users(:other_user)
    assert (user.is_regular_user? == true)
  end

  test 'User.is_regular_user as user without testcapability' do
    user = users(:other_user)
    user.update!(capabilities: 'test')
    assert (user.is_regular_user? == false)
  end

  test 'User.account_type for Forscher:in' do
    user = users(:other_user)
    assert (user.get_account_type == 'Forscher:in')
  end

  test 'User.account_type for Lehrkraft' do
    user = users(:other_user)
    user.update!(account_type: 0)
    assert (user.get_account_type == 'Lehrkraft')
  end

  test 'User.account_type for Privat' do
    user = users(:other_user)
    user.update!(account_type: 2)
    assert (user.get_account_type == 'Privat')
  end

  test 'User.get_home_info' do
    #TODO
  end

  test 'User.get_classbook_info' do
    user = users(:admin_user)

    # info for three classes (1, 2, 3(share not accepted))
    assert_equal(user.get_classbook_info.length, 3)
  end

  test 'User.new_shares for user with new shares' do
    user = users(:admin_user)
    assert_equal(user.new_shares?, true)
  end

  test 'User.new_shares for user without new shares' do
    user = users(:other_user)
    assert_equal(user.new_shares?, false)
  end

  test 'User.has_security with security digest' do
    user = users(:admin_user)
    assert_equal(user.has_security?, true)
  end

  test 'User.has_security without security digest' do
    user = users(:other_user)
    assert_equal(user.has_security?, false)
  end

  test 'User.create_demo' do
    user = users(:admin_user)
    user.create_demo('a', 'b')
    assert_equal(user.groups.length, 3)
  end

  test 'User.has_tested_students with no tested students' do
    user = users(:admin_user)
    assert_equal(user.has_tested_students, false)
  end

  test 'User.has_tested_students with tested students' do
    #TODO add
  end
end
