module V1
  module GrapeHelper
    def user
      User.find(params[:id])
    end

    def create_meetup(friendship)
      meetup = MeetupRequest.create user_id: friendship.user_id,
                                    friend_id: friendship.friend_id,
                                    friendship: friendship
      notify_friend(friendship.friend_id) if meetup
      meetup
    end

    def notify_friend(friend_id)
      friend = User.find(friend_id)
      send_meetup_notification_to(friend)
    end

    def notify_acceptance(friend_id)
      friend = User.find(friend_id)
      send_acceptance_notification_to(friend)
    end
  end
end
