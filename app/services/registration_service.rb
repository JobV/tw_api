class RegistrationService
  class << self
    def create_user_with(params)
      device_token = params[:device_token]
      oauth_token = params[:oauth_token]
      return false unless device_token && oauth_token

      MixpanelService.register_user_creation

      key = create_user_from_provider_with(device_token, oauth_token)
      ReturnMessageService.auth_token_from key
    end

    private

    def auth_token_from(key)
      return false unless key

      response = {}
      response[:auth_token] = key.access_token.to_s
      response
    end

    def create_user_from_provider_with(device_token, oauth_token)
      @graph = Koala::Facebook::API.new(oauth_token)

      begin
        profile = @graph.get_object("me")
        user = create_user_from_fb(profile)
        update_fb_friends_from(user)
        Device.create(token: device_token, user_id: user.id)
        ApiKey.create(user_id: user.id)
      rescue
        nil
      end
    end

    def create_user_from_fb(profile)
      User.create(provider_id: profile["id"],
                  provider: "facebook",
                  email: profile["email"],
                  first_name: profile["first_name"],
                  last_name: profile["last_name"])
    end
  end
end
