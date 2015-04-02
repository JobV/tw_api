module V1
  class AuthApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    helpers V1::GrapeHelper

    resource :auth do
      desc "Creates and returns access_token if valid login"
      params do
        requires :login, type: String, desc: "Username or email address"
        requires :oauth_token, type: String, desc: "OAuth Token"
      end
      post :login do
        user = User.find_by_email(params[:login].downcase)

        if user && authenticated_with_provider
          key = ApiKey.create(user_id: user.id)
          {
            token: key.access_token
          }
        else
          error!('Unauthorized.', 401)
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
