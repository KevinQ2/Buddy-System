ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def admin_login_as(admin, password: "mypassword")
    post admin_login_path, params: { session: { username: admin.username, password: password } }
  end

  def user_login_as(admin, password: "mypassword")
    post admin_login_path, params: { session: { username: admin.username, password: password } }
  end
end
