module V1
  class AuthApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    helpers V1::GrapeHelper

    resource :auth do
      desc "Creates and returns access_token if valid login, creates new user if new credentials"
      params do
        requires :login, type: String, desc: "Username or email address"
        requires :oauth_token, type: String, desc: "OAuth Token"
        requires :device_token, type: String, desc: "device token"
      end
      post :login do
        user_email = params[:login].downcase
        user = User.find_by(email: user_email)
        if user
          AuthenticationService.authenticate_user
        else
          RegistrationService.create_user
        end
      end

      desc "Destroys login token"
      params do
        requires :token, type: String, desc: "Access token."
      end
      delete :logout do
        AuthenticationService.logout_user
      end
    end
  end
end
