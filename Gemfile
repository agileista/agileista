source 'https://rubygems.org'

gem 'rails', '4.2.10'

gem 'pg'
gem 'yajl-ruby'
gem 'will_paginate', '~> 3.0'
gem 'newrelic_rpm'
gem 'newrelic-redis'
gem 'tire'
gem 'gravtastic'
gem 'ranked-model'
gem 'hiredis', '~> 0.5.0'
gem 'redis', require: ['redis/connection/hiredis', 'redis']
gem 'simple_form'
gem 'devise'
gem 'unicorn'
gem 'rack-timeout'
gem 'sidekiq', '~> 4'
gem 'whenever', require: false
gem 'hipchat'
gem 'slack-notifier'

gem 'sass-rails',   '~> 4.0.5'

gem 'foundation-rails', '5.2.3.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'turbolinks'
gem 'figaro'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'ruby-prof'
  gem 'brakeman', require: false
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof'

  gem 'uglifier', '>= 1.3.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'letter_opener'
  gem 'thin'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-console', require: false
  gem 'shoulda-matchers', require: false
  gem 'machinist'
  gem 'timecop'
end

group :development, :test do
  gem 'rubocop', require: false
  gem 'coveralls', '>= 0.8.0', require: false
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'capybara'
  gem 'faker'
end
