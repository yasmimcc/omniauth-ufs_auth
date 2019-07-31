require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class UfsAuth < OmniAuth::Strategies::OAuth2
      # strategy name
      option :name, "ufs_auth"
      
      option :client_options, {
        #:full_host => 'https://project.dcomp.ufs.br',
        :site => 'https://apisistemas.desenvolvimento.ufs.br',
        #:authorize_url => 'https://apisistemas.desenvolvimento.ufs.br/api/rest/authorization',
        :authorize_url => '/api/rest/authorization',
        :token_url => '/api/rest/token'
        #:token_url => 'https://apisistemas.desenvolvimento.ufs.br/api/rest/token'
      }

      option :provider_ignores_state, true

#      option :auth_token_params, {
#        :client_secret => ENV['UFS_SECRET']
#      }

#      option :token_params, {
#        :grant_type => 'client_credentials'
#      }

      def request_phase
        super
      end
      
      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid do
        puts '>>> uid'
        puts raw_info
        puts raw_info['arquivo']['id'].to_s
#	{
        raw_info['arquivo']['id'].to_s
#	}
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
      
      def callback_phase
        puts 'Oi!'
        puts request.params
        super
      end

      def build_access_token
        puts '>>> NEW build_access_token'
        puts options.auth_token_params
        puts callback_url
        puts token_params
        #at = super
        #puts at
        #at
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, {:redirect_uri => callback_url, :client_id => options.client_id,
            #:client_id => ENV['UFS_KEY'],
            #:client_secret => ENV['UFS_SECRET']
            :client_secret => options.client_secret
          }.merge(token_params.to_hash(:symbolize_keys => true)),
          deep_symbolize(options.auth_token_params))
      end

      info do
        puts '>>> info'
        #logger.info @raw_info.inspect
        name = raw_info['pessoa']['nome']
        nfo = {
          'email' => raw_info['pessoa']['email'],
          'name' => name,
          'first_name' => name.split(/\s/).first,
          'last_name' => name.split(/\s/).last,
        }
        puts nfo
        puts env['omniauth.auth']
        #red = env['omniauth.auth'].credentials
        puts 'tk', access_token.token
        puts 'ref_tk', self.access_token.refresh_token
        puts 'exp_at', access_token.expires_at
        puts 'exps', access_token.expires?
        puts 'expd', access_token.expired?
        nfo
      end
      
      #extra do
      #  puts '>>> extra'
      #  {
      #    'raw_info' => raw_info
      #  }
      #end

      def raw_info
        @raw_info ||= access_token.get('/api/rest/usuario').parsed
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
