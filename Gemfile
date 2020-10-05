source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.7.1'

gem 'rails', '6.0.3.2'
gem 'pg'
gem 'puma'
gem 'bootsnap', require: false

# Auth0
gem 'activerecord-session_store'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'omniauth-auth0', '~> 2.2'

# Parse XML Files to render
gem 'nokogiri'

# CSS / Assets
gem 'webpacker'
gem 'font_awesome5_rails'
gem 'jquery-rails'
gem 'bootstrap'
gem 'coffee-rails'
gem 'turbolinks'
gem 'groupdate'
gem 'sass-rails'

# Templating
gem 'slim-rails'

# pagination
gem 'kaminari'
gem 'bootstrap4-kaminari-views'

# Exception tracking
gem 'honeybadger'

# Nice Datestamps
gem 'stamp'

# Search
gem 'searchkick'


group :development, :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'pry'
  gem 'pry-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'listen'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'solargraph'
end

