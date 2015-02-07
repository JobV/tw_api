# How it works:
#
# 1. v - You tap a friend to request a meetup
# 2. x - the friend gets a push notification and can accept or decline the request
# 3. x - if the friend accepts, you start sharing location

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

          desc "Request or Accept a meetup"
          params do
            requires :friend_id, type: Integer, desc: "Friend id."
          end
          post do
            meetup = MeetupRequest.find_by(
              user: user,
              friend_id: params[:friend_id],
              created_at: (Time.now - 1.hour)..Time.now)

            if meetup
              # If exists, accept
              meetup.status = accepted
              meetup.save
            else
              # If not, check if friendship exists
              friendship = Friendship.find_by(user: user, friend_id: params[:friend_id])
              if friendship
                # If friends, create meetup request
                MeetupRequest.create(
                  user: user,
                  friend_id: params[:friend_id],
                  friendship: friendship)
              else
                error! 'Access Denied', 403
              end
            end
          end
        end
      end
    end
  end
end
