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

          desc "Request a meetup"
          params do
            requires :friend_id, type: Integer, desc: "Friend id."
          end
          post do
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

          desc "Accept a meetup"
          params do
            requires :friend_id, type: Integer, desc: "Friend id."
          end
          post '/accept' do
            meetup = MeetupRequest.find_by(
              user_id: params[:friend_id],
              friend_id: user.id,
              created_at: (Time.now - 1.hour)..Time.now)

            if meetup
              meetup.status = 'accepted'
              error! 'Access Denied', 403 unless meetup.save
            else
              error! 'Access Denied', 404
            end
          end
        end
      end
    end
  end
end
