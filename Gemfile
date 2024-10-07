source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.5'

gem 'airbrake', '~> 13.0'
gem 'aws-sdk-s3', '~> 1.160'
gem 'bundler', '= 2.4.19'
gem 'doorkeeper', '~> 5.7'
gem 'doorkeeper-jwt', '~> 0.4'
gem 'elasticsearch', '= 7.9.0'
gem 'faraday', '~> 1.10'
gem 'input_sanitizer', '~> 0.6'
gem 'logstash-event', '~> 1.2'
gem 'parallel', '~> 1.26'
gem 'pg', '~> 1.5'
gem 'puma', '~> 6.4'
gem 'rails', '= 7.1.4'
gem 'rexml', '~> 3.3'
gem 'searchkick', '~> 5.4'
gem 'sidekiq', '~> 7.3'
gem 'sidekiq-failures', '~> 1.0'

group :development do
  gem 'listen', '~> 3.9'
  gem 'pry-rails', '~> 0.3'
end

group :development, :test do
  gem 'byebug', '~> 11.1'
  gem 'factory_bot_rails', '~> 6.4'
  gem 'faker', '~> 3.4'
end

group :test do
  gem 'minitest-spec-rails', '~> 7.3'
  gem 'webmock', '~> 3.23'
end
