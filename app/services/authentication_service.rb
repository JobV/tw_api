class AuthenticationService
  class << self
    def authenticate_user_with(user, params)
      oauth_token = params[:oauth_token]
      return unless oauth_token
      return false unless authenticated_with_provider(oauth_token)

      MixpanelService.register_login

      FacebookService.update_fb_friends_from(user, oauth_token)

      ApiKey.create(user_id: user.id)
    end

    def logout_with_token(token)
      if logout(token)
        MixpanelService.register_logout
        ReturnMessageService.successful_logout
      else
        ReturnMessageService.unsuccessful_logout
      end
    end

    private

    def authenticated_with_provider(oauth_token)
      @graph = Koala::Facebook::API.new(oauth_token)

      begin
        @graph.get_object("me")
      rescue
        false
      end
    end

    def logout(token)
      apikey = ApiKey.find_by(access_token: token)
      apikey ? apikey.destroy : false
    end
  end
end
