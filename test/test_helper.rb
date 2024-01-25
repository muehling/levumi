ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Consider setting MT_NO_EXPECTATIONS to not add expectations to Object.
# ENV["MT_NO_EXPECTATIONS"] = true

module LoginAdminHelper
  def login_as(user)
    #TODO figure out how to store pw in user fixtures
    post login_url(email: user.email, password: '123')
  end
end

module FetchHelpers
  def fetch_users
    get users_url, headers: { 'Accept': 'application/json' }
    JSON.parse(@response.body)
  end

  def fetch_tests
    get tests_url, headers: { 'Accept': 'application/json' }
    JSON.parse(@response.body)
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
