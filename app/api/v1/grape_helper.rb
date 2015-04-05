module V1
  module GrapeHelper
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def logout
      apikey = ApiKey.find_by(access_token: params[:token])
      apikey ? apikey.destroy : false
    end

    def update_fb_friends
      @graph = Koala::Facebook::API.new(params[:oauth_token])

      begin
        friends = @graph.get_connections("me", "friends")
        sync_fb_friends(friends)
      rescue Exception => e
          Rails.logger.info "update_fb_friends: #{e}"
        false
      end
    end

    def sync_fb_friends(friends)
      user = User.find_by(email: params[:login])
      ActiveRecord::Base.transaction do
        friends.each do |friend|
          u = User.find_by(provider_id: friend["id"])
          user.friends << u if u && !user.friends.exists?(u)
        end
      end
    end

    def create_user_from_provider_with(device_token)
      @graph = Koala::Facebook::API.new("CAAMD72QdaUoBABRxUOXExgRQqJeFRoA0X25fzov8EEHz1zeByPeVD6NaGVOzKq0KyG56ZCzKVKrUYhadtIXW57Y69doCkVZCZBjT7fCWOvS3mLXr3UhdFXcfhklynXKQwKtnBzk5wRxLZCrHGcbcfZAZC8pRDUgnzCUFoebdk1v3T887lhim1lY6HwnTB1sKyO2ZAMqrSZBFI6GvGXdlym89D7DsSHtAVa4ZD")
      Rails.logger.info "OAUTH token: #{params[:oauth_token]}"
      begin
        profile = @graph.get_object("me")
        user = create_user_from_fb(profile)

        Device.create(token: device_token, user_id: user.id)
        ApiKey.create(user_id: user.id)
      rescue Exception => e
        Rails.logger.info "EXCEPTION IN create_user_from_provider_with: #{e}"
        false
      end
    end

    def create_user_from_fb(profile)
      Rails.logger.info "create_user_from_provider_with: #{profile.inspect}"
      User.create!(provider_id: profile["id"],
                  provider: "facebook",
                  email: profile["email"],
                  first_name: profile["first_name"],
                  last_name: profile["last_name"])
    end

    def authenticated_with_provider
      @graph = Koala::Facebook::API.new(params[:oauth_token])
      begin
        @graph.get_object("me")
      rescue
        Rails.logger.info "exception in authenticated with provider"
        false
      end
    end

    def current_user
      token = ApiKey.where(access_token: params[:token]).first
      if token && !token.expired?
        Rails.logger.info "Current User: #{User.find(token.user_id).inspect}"
        @current_user = User.find(token.user_id)
      else
        Rails.logger.info "Current User couldn't find token"
        false
      end
    end

    def create_meetup(friendship)
      meetup = MeetupRequest.create user_id: friendship.user_id,
                                    friend_id: friendship.friend_id,
                                    friendship: friendship
      notify_friend(friendship.friend_id, friendship.user_id) if meetup
      meetup
    end

    def get_status_with_friend(user_id, friend_id)
      meetup = MeetupRequest.where(user_id: user_id, friend_id: friend_id).last
      reverse_meetup =  MeetupRequest.where(user_id: friend_id, friend_id: user_id).last

      if not_first_meeting(meetup, reverse_meetup)
        get_status_from_last_meetup(meetup, reverse_meetup)
      else
        "ready"
      end
    end

    def get_status_from_last_meetup(meetup, reverse_meetup)
      if created_by_user(meetup, reverse_meetup)
        meetup.finished? ? "ready" : meetup.status
      else
        reverse_meetup.finished? ? "ready" : status_of(reverse_meetup)
      end
    end

    def created_by_user(meetup, reverse_meetup)
      return false if meetup.nil?
      return true if reverse_meetup.nil?
      meetup.updated_at > reverse_meetup.updated_at
    end

    def not_first_meeting(meetup, reverse_meetup)
      !(meetup.nil? && reverse_meetup.nil?)
    end

    def status_of(reverse_meetup)
      if reverse_meetup.pending?
        "waiting"
      else
        reverse_meetup.status
      end
    end

    def notify_friend(friend_id, sender_id)
      friend = User.find(friend_id)
      sender = User.find(sender_id)
      send_meetup_notification_to(friend, sender)
    end

    def notify_acceptance(friend_id, sender_id)
      friend = User.find(friend_id)
      sender = User.find(sender_id)
      send_acceptance_notification_to(friend, sender)
    end

    def notify_refusal(friend_id, sender_id)
      friend = User.find(friend_id)
      sender = User.find(sender_id)
      send_refusal_notification_to(friend, sender)
    end

    def notify_termination(friend_id, sender_id)
      friend = User.find(friend_id)
      sender = User.find(sender_id)
      send_termination_notification_to(friend, sender)
    end

    def find_meetup(friend_id, user_id)
      MeetupRequest.where(
      "(user_id = :friend_id AND friend_id = :user_id )
      OR (user_id = :user_id AND friend_id = :friend_id )",
      friend_id: friend_id,
      user_id: user_id).last
    end
  end
end
