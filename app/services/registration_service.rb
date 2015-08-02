class RegistrationService
  class << self
    def create_user
      device_token = params[:device_token]
      if device_token
        MixPanelService.register_user_creation
        key = create_user_from_provider_with(device_token)
        {
          auth_token: key.access_token.to_s
        }
      else
        error!('Unauthorized.', 401)
      end
    end

    private

    def create_user_from_provider_with(device_token)
      @graph = Koala::Facebook::API.new(params[:oauth_token])

      begin
        profile = @graph.get_object("me")
        user = create_user_from_fb(profile)
        update_fb_friends_from(user)
        Device.create(token: device_token, user_id: user.id)
        ApiKey.create(user_id: user.id)
      rescue
        false
      end
    end

    def create_user_from_fb(profile)
      User.create!(provider_id: profile["id"],
                   provider: "facebook",
                   email: profile["email"],
                   first_name: profile["first_name"],
                   last_name: profile["last_name"])
    end
  end
end
