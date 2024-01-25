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

    assert_equal parsed['users'].length, 4
    assert_equal parsed['users'].first['email'], 'admin@example.com'
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
    assert_equal parsed['users'].length, 5
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
    assert_equal parsed['users'].length, 5
  end

  test 'UsersController::destroy' do
    user = users :admin_user
    login_as user

    delete user_url(user.id), headers: { 'Accept': 'application/json' }

    # delete self, not possible
    assert_response :success # debatable, no one has been deleted
    parsed = fetch_users
    assert_equal parsed['users'].length, 4

    # delete other user
    user = users :other_user
    delete user_url(user.id), headers: { 'Accept': 'application/json' }
    assert_response :success
    parsed = fetch_users
    assert_equal parsed['users'].length, 3
    #test if other user is still there
    assert_equal parsed ['users'].include?(user.id), false
  end
 
  test 'UsersController::search -> no admin user' do
    user = users :other_user
    login_as user
    
    get "#{users_search_url}?search_term=admin"

    assert_response :forbidden
  end 

  test 'UsersController::search -> admin user' do
    user = users :admin_user
    login_as user
    
    get "#{users_search_url}?search_term=admin"

    assert_response :ok
  end 

  test 'UsersController::search -> test user' do
    user = users :hacker_user
    login_as user
    
    get "#{users_search_url}?search_term=admin"

    assert_response :forbidden
  end
  
  test 'UsersController::search -> (Mail) right number of hits ' do
    user = users :admin_user
    login_as user
    
    get "#{users_search_url}?search_term=@example", headers: {
      'Accept': 'application/json'
    }
    parsed = JSON.parse(@response.body)
    assert_equal parsed['total_users'], 4
  end 

  test 'UsersController::search -> (Date) right number of hits' do
    user = users :admin_user
    login_as user
    
    get "#{users_search_url}?start_date_registration='2022-11-16 07:34:57.117653'&end_date_registration='2022-11-16 07:34:57.117653'", headers: {
      'Accept': 'application/json'
    }
    parsed = JSON.parse(@response.body)
    assert_equal parsed['total_users'], 3
  end 

  test 'UsersController::search -> (Last Login) right number of hits' do
    user = users :admin_user
    login_as user
    
    get "#{users_search_url}?start_date_login='2020-11-16 07:34:57.117653'&end_date_login='2023-11-16 07:34:57.117653'", headers: {
      'Accept': 'application/json'
    }
    parsed = JSON.parse(@response.body)
    assert_equal parsed['total_users'], 1
  end 

  test 'UsersController::register -> no User' do
    get willkommen_url
    assert_redirected_to('/')
  end

  test 'UsersController::register -> new User' do
    user = users :hacker_user
    login_as user
    get willkommen_url
    assert_equal('http://www.example.com/willkommen',@response.request.url)
  end

  test 'UsersController::register -> intro state 1' do
    user = users :hacker_user
    login_as user
    patch willkommen_url, 
    headers: {
      'Accept': 'application/json'
    },
    params: {
      user: {
        email: 'hacker@example.com',
        account_type: 1,
        state: 1,
      },
    }
    assert_response :ok
  end

  test 'UsersController::register -> intro state 3' do
    user = users :teaching_user
    login_as user
    patch willkommen_url
    assert_response :ok
  end
  
 

end
