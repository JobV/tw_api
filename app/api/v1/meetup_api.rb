module V1
  class MeetupApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all

    helpers do
      def current_user
        User.find(params[:id])
      end
    end

    resource :users do
      route_param :id do
        resource :meetups do
          desc "Return received pending meetups"
          get do
            {
              "received" => current_user.pending_meetup_requests_received
            }
          end

          desc "Return sent pending meetups"
          get do
            {
              "sent" => current_user.pending_meetup_requests_sent
            }
          end

          desc "Creating a meetup"
          params do
            requires :friend_id, type: Integer, desc: "User id."
          end
          post do
            if friend = User.find(params[:friend_id])
              meetup = current_user.request_meetup_with(friend) if current_user.friends.exists?(friend)
            end
            {
              "success" => meetup
            }
          end
        end
      end
    end
  end
end
