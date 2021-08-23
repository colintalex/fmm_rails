source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.4', '>= 6.0.4.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'jsonapi-serializer'
gem 'rack-cors'
gem 'bcrypt', '~> 3.1.7'
gem 'jwt'
gem 'bootsnap', '>= 1.4.2', require: false

group :test do 
  gem 'shoulda-matchers', '~> 4.0'
  gem 'simplecov', require: false
  gem 'codecov', :require => false
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 5.0.1'
  gem 'pry', '~> 0.13.1'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
