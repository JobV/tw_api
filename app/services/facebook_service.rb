class FacebookService
  class << self
    def update_fb_friends_from(user, oauth_token)
      @graph = Koala::Facebook::API.new(oauth_token)

      begin
        friends = @graph.get_connections("me", "friends")
        sync_fb_friends(user, friends)
      rescue
        false
      end
    end
  end
end
