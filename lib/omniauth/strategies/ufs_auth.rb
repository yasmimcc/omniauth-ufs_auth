require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class UfsAuth < OmniAuth::Strategies::OAuth2
      # strategy name
      option :name, "ufs_auth"
      
      option :client_options, {
        :site => 'https://apisistemas.desenvolvimento.ufs.br',
        :authorize_url => '/api/rest/authorization',
        :token_url => '/api/rest/token'
      }

      option :provider_ignores_state, true
      
      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info['login'].to_s }

      # required user info used in OpenProject
      info do
        name = raw_info['pessoa']['nome']
        {
          'email' => raw_info['pessoa']['email'],
          'name' => name,
          'first_name' => name.split(/\s/).first,
          'last_name' => name.split(/\s/).last,
        }
      end
      
      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/rest/usuario').parsed
      end
      
      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {
          :redirect_uri => callback_url,
          :client_id => options.client_id,
          :client_secret => options.client_secret
        }.merge(token_params.to_hash(:symbolize_keys => true)),
        deep_symbolize(options.auth_token_params))
      end
      
      def callback_url
        full_host + script_name + callback_path
      end
      
      def ssl?
        true
      end
    end
  end
end

OmniAuth.config.add_camelization 'ufs_auth', 'UfsAuth'
