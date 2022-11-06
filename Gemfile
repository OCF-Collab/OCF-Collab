source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'rails', '= 6.1.6.1'
gem 'pg'
gem 'puma', '~> 4.1'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.13', require: false

gem 'doorkeeper', '~> 5.6'
gem 'doorkeeper-jwt', '0.4.0'
gem 'aws-sdk-s3', '~> 1.117'
gem 'sidekiq', '6.1.2'
gem 'searchkick', '~> 4.6'
gem 'input_sanitizer', '~> 0.5'
gem 'faraday', '~> 1.10'
gem 'logstash-event'
gem 'rexml', '~> 3.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.0'
end

group :development do
  gem 'listen', '~> 3.7'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-rails', '0.3.9'
end

group :test do
  gem 'minitest-spec-rails', '~> 6.2'
  gem 'webmock'
end
