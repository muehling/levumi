require 'test_helper'
require 'json'

class TestsControllerTest < ActionDispatch::IntegrationTest
  include LoginAdminHelper
  include FetchHelpers

  test 'TestsController::index' do
    user = users :admin_user
    login_as user

    parsed = fetch_tests

    assert_equal parsed['tests'].length, 2
    assert_equal parsed['tests'].first['shorthand'], 'writing N1'
    assert_equal parsed['tests'].first['area'], 'Deutsch'
    assert_equal parsed['tests'].first['competence'], 'Rechtschreibung'

    assert_equal parsed['tests'].second['student_test'], true
  end

  test 'TestsController::show' do
    user = users :admin_user
    login_as user

    test = tests :writing_n1
    get test_url(test.id)
    assert_response :success
    # TODO what else to test?
  end

  test 'TestsController::create with valid zip' do
    user = users :admin_user
    login_as user

    post tests_path,
         headers: {
           'Accept': 'application/zip'
         },
         params: {
           test: {
             file: fixture_file_upload('test.zip')
           }
         }
    assert_response :success
  end

  test 'TestsController::create with invalid zip' do
    user = users :admin_user
    login_as user

    post tests_path,
         headers: {
           'Accept': 'application/zip'
         },
         params: {
           test: {
             file: fixture_file_upload('false_test.zip')
           }
         }
    assert_response :unprocessable_entity
  end

  test 'TestsController::create with empty zip' do
    user = users :admin_user
    login_as user

    post tests_path,
         headers: {
           'Accept': 'application/zip'
         },
         params: {
           test: {
             file: fixture_file_upload('empty_test.zip')
           }
         }
    assert_response :unprocessable_entity
  end

  # not testable atm
  #  test 'TestController::update' do
  #    user = users :admin_user
  #    login_as user
  #
  #    test = tests :writing_n1
  #
  #    put test_path(test.id), params: { test: { name: 'changed' } }
  #    parsed = JSON.parse(@response.body)
  #
  #    assert_response :success
  #    assert parsed['name'] == 'changed'
  #  end

  test 'TestsController::destroy' do
    user = users :admin_user
    login_as user
    test = tests :writing_n1

    delete test_url(test.id), headers: { 'Accept': 'application/json' }
    assert_response :success
    parsed = fetch_tests
    assert_equal parsed['tests'].length, 1
  end

  test 'TestsController::get_test_data' do
    user = users :admin_user
    login_as user

    get tests_info_url, headers: { 'Accept': 'application/json' }
    assert_response :success
    info = JSON.parse(@response.body)
    t = info['tests']

    assert_equal t[0]['name'], 'Deutsch'
    assert_equal t[0]['competences'].count, 2
    assert_equal t[0]['competences'][0]['test_families'][0]['name'], 'Wörter schreiben'
  end

  test 'TestsController::get_items -> two items' do 
  user = users :admin_user
  login_as user
  test = tests :writing_n1

  get "/tests/items/#{test.id}"
  info = JSON.parse(@response.body)

  assert_equal info.length(), 2
  end

  #no items
  test 'TestsController::get_items ->no items ' do 
    user = users :admin_user
    login_as user
    test = tests :writing_n2
  
    get "/tests/items/#{test.id}"
    info = JSON.parse(@response.body)
    
    assert_equal info.length(), 0
  end

  test 'TestsController::get_items ->no Test ' do 
    user = users :admin_user
    login_as user
    
    get "/tests/items/420"
  
    assert_response :not_found
  end
#not finished yet
#  test 'check_upload_version' do 
 #   user = users :admin_user
  #  login_as user
   # test = tests :writing_n1
    #post :change_avatar, params: { avatar: file_fixture_upload('uploadable_test.zip', 'application/zip') }


    #post check_upload_version
    #info = JSON.parse(@response.body)
    #puts info


  #end



end
