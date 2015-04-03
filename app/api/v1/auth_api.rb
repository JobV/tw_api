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
      end
      post :login do
        user_email = params[:login].downcase
        user = User.find_by(email: user_email)

        if user && !user_email.empty?
          if authenticated_with_provider
            key = ApiKey.create(user_id: user.id)
            {
              auth_token: key.access_token.to_s
            }
          else
            error!('Unauthorized.', 401)
          end
        else
          key = create_user_from_provider
          {
            auth_token: key.access_token.to_s
          }
        end

      end

      desc "Destroys login token"
      params do
        requires :token, type: String, desc: "Access token."
      end
      delete :logout do
        if logout
          {
            success: "logout was successful"
          }
        else
          {
            error: "logout was unsuccessful"
          }
        end
      end
    end
  end
end
