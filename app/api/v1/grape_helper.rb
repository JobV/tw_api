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

      if meetup.updated_at > reverse_meetup.updated_at
        if meetup
          if meetup.status == "terminated" || meetup.status == "declined"
            "ready"
          else
            meetup.status
          end
        else
          "ready"
        end
      else
        if reverse_meetup
          if reverse_meetup == "terminated" || reverse_meetup.status == "declined"
            "ready"
          else
            if reverse_meetup.status == "pending"
              "waiting"
            else
              "ready"
            end
          end
        else
          "ready"
        end
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
