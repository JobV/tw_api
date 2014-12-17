source 'https://rubygems.org'


gem 'rails', '4.1.8'
gem 'pg'
gem 'sass-rails', '~> 4.0.3'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'turbolinks'

gem 'spring',        group: :development

# Build API
gem 'grape'
gem 'hashie_rails' # use in case of mass-assignment problems wth grape

# RGeo + Postgis adapter
gem 'activerecord-postgis-adapter'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :development do
  gem 'annotate' # annotate models
  gem 'guard-rspec', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem "factory_girl_rails", "~> 4.0"
end
