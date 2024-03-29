module V1
  class AuthApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    helpers V1::GrapeHelper

    resource :auth do
      desc "Creates and returns access_token if valid login, creates new user if new credentials"
      params do
        requires :login, type: String, desc: "provider id"
        requires :oauth_token, type: String, desc: "OAuth Token"
        requires :device_token, type: String, desc: "device token"
      end
      post :login do
        user_provider_id = params[:login].downcase
        user = User.find_by(provider_id: user_provider_id)
        key = {}

        if user
          key = AuthenticationService.authenticate_user_with(user, params)
        else
          key = RegistrationService.create_user_with(params)
        end

        key ? ReturnMessageService.auth_token_from(key) : error!('Unauthorized.', 401)
      end

      desc "Destroys login token"
      params do
        requires :token, type: String, desc: "Access token."
      end
      delete :logout do
        token = params[:token]
        if token
          AuthenticationService.logout_with_token(token)
        else
          error!('Unauthorized.', 401)
        end
      end
    end
  end
end
