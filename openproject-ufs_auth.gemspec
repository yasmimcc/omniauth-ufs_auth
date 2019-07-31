# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/ufs_auth/version'

Gem::Specification.new do |s|
  s.name        = "openproject-ufs_auth"
  s.version     = OpenProject::UfsAuth::VERSION
  s.authors     = "Yasmim Reinert"
  s.email       = "yasmimcc@gmail.com"
  s.homepage    = "https://github.com/yasmimcc/openproject-ufs_auth"
  s.summary     = 'OpenProject UfsAuth'
  s.description = "Adds a UfsAuth omniauth strategy to Openproject."
  s.license     = "GPLv3"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", ">= 5.0.4"
end
