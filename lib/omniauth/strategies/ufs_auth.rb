require 'securerandom'
require 'omniauth/strategy'

module OmniAuth
  module Strategies
    ##
    # The ufs authentication strategy simply shows a form where you provide the user info.
    # Users are identified by their email address. I.e. when you want to login with a user you created
    # before using the ufs auth strategy, you just have to provide the same email address in the form.
    class UfsAuth < OmniAuth::Strategies::OAuth2

      option :fields, [:name, :email]
      option :client_options, {
        :site => 'https://apisistemas.desenvolvimento.ufs.br',
        :authorize_url => 'https://apisistemas.desenvolvimento.ufs.br/api/rest/authorization',
        :token_url => 'https://apisistemas.desenvolvimento.ufs.br/api/rest/token'
      }

      def request_phase
        super
      end

      # required to identify the user in OpenProject
      uid do
        info[options.uid_field]
      end

      # required user info used in OpenProject
      # info do
      #   name = request.params['name']
      #   {
      #     name: name,
      #     email: request.params['email'],
      #     first_name: name.split(/\s/).first,
      #     last_name: name.split(/\s/).last,
      #   }
      # end
      info do
        logger.info @raw_info.inspect
        {
          #'nickname' => raw_info['login'],
          'email' => raw_info['email'],
          'name' => raw_info['name']
        }
      end
    end
  end
end
