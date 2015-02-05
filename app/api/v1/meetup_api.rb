module V1
  class MeetupApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all
    helpers V1::GrapeHelper

    resource :users do
      route_param :id do
        resource :meetups do
          desc "Return received pending meetups"
          get do
            {
              "received" => user.pending_meetup_requests_received
            }
          end

          desc "Creating a meetup"
          params do
            requires :friend_id, type: Integer, desc: "User id."
          end
          post do
            friend = User.find(params[:friend_id])
            meetup = user.request_meetup_with(friend) if friend && user.friends.exists?(friend)
            {
              "success" => meetup
            }
          end
        end
      end
    end
  end
end
