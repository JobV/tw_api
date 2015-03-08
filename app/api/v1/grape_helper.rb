module V1
  module GrapeHelper
    def user
      User.find(params[:id])
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
  end
end
