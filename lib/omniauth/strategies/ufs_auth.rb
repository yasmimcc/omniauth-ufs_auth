require 'securerandom'
require 'omniauth/strategy'

module OmniAuth
  module Strategies
    ##
    # The ufs authentication strategy simply shows a form where you provide the user info.
    # Users are identified by their email address. I.e. when you want to login with a user you created
    # before using the ufs auth strategy, you just have to provide the same email address in the form.
    class UfsAuth
      include OmniAuth::Strategy

      option :uid_field, :email
      option :fields, [:name, :email]

      def request_phase
        csrf_token = SecureRandom.base64(32)
        request.session[:_csrf_token] = csrf_token

        form = OmniAuth::Form.new(title: 'Ufs Auth', url: callback_path)
        options.fields.each do |field|
          form.text_field field.to_s.capitalize.gsub('_', ' '), field.to_s
        end
        form.html "<input type=\"hidden\" name=\"authenticity_token\" value=\"#{csrf_token}\"/>"
        form.button 'Sign In'
        form.to_response
      end

      # required to identify the user in OpenProject
      uid do
        info[options.uid_field]
      end

      # required user info used in OpenProject
      info do
        name = request.params['name']
        {
          name: name,
          email: request.params['email'],
          first_name: name.split(/\s/).first,
          last_name: name.split(/\s/).last,
        }
      end
    end
  end
end
