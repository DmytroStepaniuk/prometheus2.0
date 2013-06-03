source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '~> 3.2'
gem 'strong_parameters'
gem 'jbuilder'
gem 'turbolinks'

gem 'rake', require: false

group :postgresql do
  gem 'pg'
end

group :mysql do
  gem 'mysql2', '0.3.12b6'
end

group :sqlite do
  gem 'sqlite3'
end

gem 'devise'
gem 'draper'
gem 'airbrake'
gem 'pry', group: [:development, :test]
gem 'kaminari'
gem 'everywhere'
gem 'fast_gettext'
gem 'gettext_i18n_rails'
gem 'gettext', require: false
gem 'whenever', require: false
gem 'nested_set'
gem 'mysql2', '0.3.12b6' # for thinking-sphinx
gem 'thinking-sphinx'
gem 'brewdler', require: false
gem 'sitemap_generator'
gem 'backup', require: false
gem 'coderay'

group :production, :development, :staging do
  gem 'redis'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

group :production do
  gem 'dalli'
  gem 'newrelic_rpm'
#  gem 'newrelic-redis'
  gem 'rack-force_domain'
  gem 'exception_notification'
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end

group :staging do
  gem 'dalli'
  gem 'active_sanity'
end

group :development do
  gem 'rails-erd'
  gem 'sextant'
  gem 'quiet_assets'
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'capistrano', require: false
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
end

group :development, :test do
  gem 'hirb'
  gem 'wirb'
  gem 'rspec'
  gem 'rspec-rails'
#  gem 'debugger'
end

group :test do
  gem 'capybara'
  # gem 'ffaker'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'email_spec'
  gem 'launchy'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'fakeweb'
  gem 'fakeredis'
  gem 'factory_girl_rails'
end
