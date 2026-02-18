require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Manually require these to ensure they are loaded before configuration
require 'database_cleaner/active_record'
require 'shoulda/matchers'
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }
# Shoulda Matchers config
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # Include FactoryBot Methods
  config.include FactoryBot::Syntax::Methods

  # DatabaseCleaner Configuration
  config.before(:suite) do
    # Use 'deletion' or 'truncation' to reset the DB state once at the start
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    # Standard transaction strategy for speed
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    # For future proofing: feature specs usually need truncation
    DatabaseCleaner.strategy = :deletion
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.fixture_paths = [Rails.root.join('spec/fixtures')]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include RequestSpecHelper
  config.include ControllerSpecHelper
end