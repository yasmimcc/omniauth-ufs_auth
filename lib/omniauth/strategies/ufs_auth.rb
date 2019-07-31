require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class UfsAuth < OmniAuth::Strategies::OAuth2
      # strategy name
      option :name, "ufs_auth"
      
      option :client_options, {
        :site => 'https://apisistemas.desenvolvimento.ufs.br/api/rest',
        :authorize_url => 'https://apisistemas.desenvolvimento.ufs.br/api/rest/authorization',
        :token_url => 'https://apisistemas.desenvolvimento.ufs.br/api/rest/token'
      }

      def request_phase
        super
      end
      
      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['arquivo']['id'] }

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
        name = raw_info['pessoa']['nome']
        {
          email: raw_info['pessoa']['email'],
          name: name,
          first_name: name.split(/\s/).first,
          last_name: name.split(/\s/).last
        }
      end
      
      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/usuario').parsed
      end
    end
  end
end
