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
        Rails.logger.info "============================"
        Rails.logger.info "Params: #{params}"
        Rails.logger.info "============================"
        if user
          if authenticated_with_provider
            Rails.logger.info "======== user authenticated =========="
            update_fb_friends_from(user)
            key = ApiKey.create(user_id: user.id)
            {
              auth_token: key.access_token.to_s
            }
          else
            error!('Unauthorized.', 401)
          end
        else
          Rails.logger.info "======== user not found =========="
          device_token = params[:device_token]
          if device_token
            Rails.logger.info "======== device_token =========="
            Rails.logger.info "Device_Token: #{device_token}"
            key = create_user_from_provider_with(device_token)
            {
              auth_token: key.access_token.to_s
            }
          else
            error!('Unauthorized.', 401)
          end
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
