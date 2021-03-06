# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'
# Slim template engine
gem 'slim-rails'
# Devise
gem 'devise'

# Amazon S3
gem 'aws-sdk-s3', require: false

# nested forms
gem 'cocoon'

# Gists API NETWORKING
gem 'octokit', '~> 4.0'

gem 'gon'

gem 'capybara-email'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-vkontakte'

# Authorization
gem 'cancancan'
# OAuth provider
gem 'doorkeeper'

# Serializers
gem 'active_model_serializers', '~> 0.10'

# A fast JSON parser and Object marshaller as a Ruby gem.
gem 'oj'

# Simple, efficient background processing for Ruby(for ActiveJob)
gem 'sidekiq'

# For web interface sidekiq
gem 'sinatra', require: false
# Task on time .Whenever is a Ruby gem that provides a clear syntax for writing and deploying cron jobs.
gem 'whenever', require: false

# Sphinx search
gem 'mysql2'
gem 'thinking-sphinx'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# gem 'jquery-rails'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
# Deploy assets:precompile
# gem 'mini_racer', '~> 0.6.2'

gem 'mini_racer', platforms: :ruby

# Configuration variables
gem 'dotenv-rails'

# app server
gem 'unicorn'

# Fragment Cache
gem 'redis-rails'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # Testing framework to Ruby on Rails
  gem 'rspec-rails', '~> 5.0.0'
  # Create factories to tests
  gem 'factory_bot_rails'
  # Configuration variables
  gem 'database_cleaner'
  # gem 'dotenv-rails'
  gem 'letter_opener'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # RuboCop is a Ruby static code analyzer
  gem 'rubocop', '~> 1.22', require: false
  gem 'rubocop-performance', '~> 1.11', require: false
  gem 'rubocop-rails', '~> 2.12', require: false

  # Deploy app with capistrano
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'capybara-wsl'
  gem 'fuubar'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
