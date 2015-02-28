source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '~> 4.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'rake', require: false

group :postgresql do
  gem 'pg'
end

group :sqlite do
  gem 'sqlite3'
end

gem 'devise'
gem 'draper'
gem 'pry', group: [:development, :test]
gem 'redis-objects'
gem 'kaminari'
gem 'fast_gettext'
gem 'gettext_i18n_rails'
gem 'gettext', require: false
gem 'whenever', require: false
gem 'awesome_nested_set'
gem 'mysql2' # for thinking-sphinx
gem 'thinking-sphinx'
gem 'brewdler', require: false
gem 'sitemap_generator'
gem 'backup', require: false
gem 'coderay'
# gem 'rack-rewrite'
# gem 'delorean'
gem 'childprocess'
gem 'rollbar', '~> 1.4.4'

group :production, :development, :staging do
  gem 'redis'
end

group :production, :staging do
  gem 'dalli'
end

group :production do
  gem 'newrelic_rpm'
  # gem 'newrelic-redis'
  gem 'rack-force_domain'
  gem 'exception_notification'
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'lograge'
end

group :staging do
  gem 'active_sanity'
end

group :development do
  gem 'sandi_meter', require: false
  gem 'rails-erd'
  gem 'sextant'
  gem 'quiet_assets'
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'capistrano', '2.15.5', require: false
  gem 'capistrano_colors', require: false
  gem 'guard'
  gem 'rb-fsevent', require: false
  gem 'growl', require: false
  gem 'rb-inotify', '~> 0.9', require: false
  gem 'libnotify', require: false
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'xray-rails'
  gem 'rubocop', require: false
  gem 'guard-rubocop'
  gem 'flog', require: false
  gem 'brakeman', require: false
end

group :development, :test do
  gem 'hirb'
  gem 'wirb'
  gem 'rspec'
  gem 'rspec-rails'
  # gem 'debugger'
end

group :test do
  # https://github.com/rails/rails/issues/18572
  gem 'test-unit'

  gem 'capybara'
  # gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'launchy'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'fakeweb'
  gem 'fakeredis'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
end
