require 'test_helper'
require 'json'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include LoginAdminHelper
  include FetchHelpers

  test 'UsersController::show' do
    user = users :admin_user
    login_as user

    get user_url(user.id), headers: { 'Accept': 'application/json' }
    assert_response :success
  end

  test 'UsersController::update' do
    user = users :other_user
    login_as user

    put user_url(user.id), params: { user: { town: 'Nowhere' } }
    parsed = JSON.parse(@response.body)

    assert_response :success
    assert parsed['town'] == 'Nowhere'
  end

  test 'UsersController::index' do
    user = users :admin_user
    login_as user

    parsed = fetch_users

    assert_equal parsed['users'].length, 2
    assert_equal parsed['users'].first['email'], 'admin@example.com'
  end

  test 'UsersController::destroy' do
    user = users :admin_user
    login_as user

    delete user_url(user.id), headers: { 'Accept': 'application/json' }

    # delete self, not possible
    assert_response :success # debatable, no one has been deleted
    parsed = fetch_users
    assert_equal parsed['users'].length, 2

    # delete other user
    user = users :other_user
    delete user_url(user.id), headers: { 'Accept': 'application/json' }
    assert_response :success
    parsed = fetch_users
    assert_equal parsed['users'].length, 1
  end

  test 'UsersController::create -> correct request' do
    # create new user without being logged in
    post users_url,
         headers: {
           'Accept': 'application/json'
         },
         params: {
           user: {
             email: 'newguy@example.com',
             account_type: 1,
             state: 1,
             timestamp: Time.now + 14.seconds,
             render_timestamp: Time.now,
             comment: ''
           }
         }
    assert_response :success

    # log in and check number of users
    user = users :admin_user
    login_as user
    parsed = fetch_users
    assert_equal parsed['users'].length, 3
  end

  test 'UsersController::create -> incomplete parameters' do
    post users_url,
         headers: {
           'Accept': 'application/json'
         },
         params: {
           user: {
             email: 'newguy@example.com'
           }
         }
    assert_response :forbidden
  end

  test 'UsersController::create -> register from backend' do
    user = users :admin_user
    login_as user
    post users_url,
         headers: {
           'Accept': 'application/json'
         },
         params: {
           user: {
             email: 'newguy@example.com',
             account_type: 1,
             state: 1
           }
         }
    assert_response :success
    parsed = fetch_users
    assert_equal parsed['users'].length, 3
  end
end
