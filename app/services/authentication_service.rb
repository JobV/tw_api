class AuthenticationService
  class << self
    def authenticate_user
      if authenticated_with_provider
        MixPanelService.register_login
        update_fb_friends_from(user)
        key = ApiKey.create(user_id: user.id)
        {
          auth_token: key.access_token.to_s
        }
      else
        error!('Unauthorized.', 401)
      end
    end

    def logout_user
      if logout
        MixPanelService.register_logout
        {
          success: "logout was successful"
        }
      else
        {
          error: "logout was unsuccessful"
        }
      end
    end

    private

    def authenticated_with_provider
      @graph = Koala::Facebook::API.new(params[:oauth_token])

      begin
        @graph.get_object("me")
      rescue
        false
      end
    end

    def logout
      apikey = ApiKey.find_by(access_token: params[:token])
      apikey ? apikey.destroy : false
    end
  end
end
