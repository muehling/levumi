=begin
require 'test_helper'
require 'json'

class TestsControllerTest < ActionDispatch::IntegrationTest
  include LoginAdminHelper
  include FetchHelpers

  test 'TestsController::new' do
  end

  test 'TestsController::start_demo no test_id' do
    user = users :admin_user
    login_as user
    test = tests :writing_n1

    post tests_path, headers: {}, params: { test: {test_id: } }
    assert_response :not_found
  end

  test 'TestController::create no_key' do
    user = users :admin_user
    login_as user
    test = tests :writing_n1
    post tests_path, headers: {}, params: { test: {assessment_id: } }

    assert_response :unprocessable_entity
  end

end
