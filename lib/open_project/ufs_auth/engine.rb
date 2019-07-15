# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'
require 'omniauth/strategies/ufs_auth'

module OpenProject::UfsAuth
  class Engine < ::Rails::Engine
    engine_name :openproject_ufs_authd

    include OpenProject::Plugins::ActsAsOpEngine
    extend OpenProject::Plugins::AuthPlugin

    register 'openproject-ufs_auth',
             :author_url => 'http://github.com/yasmimcc',
             :requires_openproject => '>= 4.0.0'

    register_auth_providers do
      strategy :ufs_auth do
        [{name: 'ufs_auth', display_name: 'Test Ufs'}]
      end
    end
  end
end
