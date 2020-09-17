source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
gem 'puma', '~> 4.1'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'telegram-bot-ruby'
gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'

group :development, :test do
  gem 'pg', '1.2.3'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

group :production do 
  gem 'pg', '1.2.3'
end 

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
