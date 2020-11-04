ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/mock'
require 'webmock/minitest'

require 'helpers/doorkeeper_helpers'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods

  class << self
    alias_method :context, :describe
  end
end

class ActionDispatch::IntegrationTest
  include DoorkeeperHelpers
end

WebMock.disable_net_connect!(allow: ENV["ELASTICSEARCH_URL"])
Searchkick.disable_callbacks
