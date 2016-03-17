# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

source "https://rubygems.org"
gem "rake", :require => false
gemspec

group :test do
  gem "rspec-helpers", :require => false
  gem "codeclimate-test-reporter", :require => false
  gem "luna-rspec-formatters", :require => false, :github => "envygeeks/luna-rspec-formatters"
  gem "rspec", :require => false
end

group :development do
  gem "rubocop", :github => "bbatsov/rubocop", :require => false
  gem "pry", {
    :require => false
  }
end
