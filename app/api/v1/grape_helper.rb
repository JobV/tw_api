module V1
  module GrapeHelper
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def sync_fb_friends(user, friends)
      ActiveRecord::Base.transaction do
        friends.each do |friend|
          u = User.find_by(provider_id: friend["id"])
          user.friends << u if u && !user.friends.exists?(u)
        end
      end
    end

    def current_user
      token = ApiKey.where(access_token: params[:token]).first
      if token && !token.expired?
        @current_user = User.find(token.user_id)
      else
        false
      end
    end

    def create_meetup(friendship)
      meetup = get_ongoing_meetup_between(friendship.user_id, friendship.friend_id)
      return false if meetup
      meetup = MeetupRequest.create user_id: friendship.user_id,
                                    friend_id: friendship.friend_id,
                                    friendship: friendship
      notify_friend(friendship.friend_id, friendship.user_id) if meetup
      meetup
    end

    def get_status_with_friend(user_id, friend_id)
      meetup = get_meetup_between(user_id, friend_id)
      reverse_meetup = get_meetup_between(friend_id, user_id)

      if not_first_meeting(meetup, reverse_meetup)
        get_status_from_last_meetup(meetup, reverse_meetup)
      else
        "ready"
      end
    end

    def get_meetup_between(user_id, friend_id)
      MeetupRequest.where(user_id: user_id,
                          friend_id: friend_id,
                          created_at: (Time.now - 1.hour)..Time.now).last
    end

    def get_ongoing_meetup_between(user_id, friend_id)
      MeetupRequest
        .where("friend_id = ? and user_id = ?
                and (status = ? or status = ?)
                and meetup_requests.created_at BETWEEN ? and ?", friend_id, user_id, 0, 1, (Time.now - 1.hour), Time.now).last
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
