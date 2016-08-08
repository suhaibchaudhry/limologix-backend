source 'https://rubygems.org'

# Server Stack
gem 'rails', '4.2.6'
gem 'thin'
gem 'mysql2', '0.4.4'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'faye'
gem 'faye-redis'

# Authentication
gem "bcrypt"

# Config
gem 'settingslogic'

# API
gem 'grape'
gem 'grape-swagger'
gem 'hashie-forbidden_attributes'
gem 'grape-active_model_serializers'
gem 'grape-kaminari'

# Authorization
gem 'cancancan', '~> 1.13.1'
gem 'grape-cancan'

# PaymentGateway
gem 'authorizenet'

# View
# gem 'coffee-rails', '~> 4.1.0'
# gem 'jquery-rails'
# gem 'jbuilder', '~> 2.0'
# gem 'sass-rails', '~> 5.0'
# gem 'sdoc', '~> 0.4.0', group: :doc
# gem 'turbolinks'
# gem 'uglifier', '>= 1.3.0'

# Country Master Data
gem 'city-state'

# Cross-Origin Resource Sharing
gem 'rack-cors'

# Uploads & Imports
gem 'carrierwave'
gem 'mini_magick'

group :development do
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
end

group :staging, :development do
  gem 'byebug' # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'ffaker'
end



