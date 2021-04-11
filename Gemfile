source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
# Use jdbcsqlite3 as the database for Active Record
gem 'activerecord-jdbcsqlite3-adapter'
# Use Puma as the app server
gem 'puma', '~> 5.0'

# Use SCSS for stylesheets
#gem 'sass-rails', '>= 6'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'selenium-webdriver'
gem "webdrivers"

gem "capybara"
gem "launchy"
gem 'simplecov', require: false

# For warbler 2.0.5, jRuby 9.2.9.0, Rails 6.0.1, bundler 2.0.2: Use rubyzip 1.3.0 instead of 2.0.0
# To prevent: Gem::LoadError: You have already activated rubyzip 1.3.0, but your Gemfile requires rubyzip 2.0.0. Prepending `bundle exec` to your command may solve this.
gem 'rubyzip', '1.3.0'

group :development do
  gem 'listen', '~> 3.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
