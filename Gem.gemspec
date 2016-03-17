# Frozen-string-literal: true
# Copyright: 2015-2016 Jordon Bedwell - MIT License
# Encoding: utf-8

$LOAD_PATH.unshift(File.expand_path("../lib", __FILE__))
require "forwardable/extended/version"

Gem::Specification.new do |spec|
  spec.authors = ["Jordon Bedwell"]
  spec.version = Forwardable::Extended::VERSION
  spec.files = %W(Rakefile Gemfile LICENSE) + Dir["{lib,bin}/**/*"]
  spec.description = "Forwardable with hash, and instance variable extensions."
  spec.summary = "Forwardable with hash, and instance variable extensions."
  spec.homepage = "http://github.com/envygeeks/forwardable-extended"
  spec.email = ["jordon@envygeeks.io"]
  spec.name = "forwardable-extended"
  spec.require_paths = ["lib"]
  spec.license = "MIT"
  spec.has_rdoc = false
  spec.bindir = "bin"
end
