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
    helpers ApnsHelper

    resource :users do
      resource :meetups do
        desc "Return ongoing meetups"
        params do
          requires :token, type: String, desc: "Access token."
        end
        get do
          authenticate!
          {
            "meetups" => current_user.ongoing_meetups
          }
        end

        desc "Request a meetup"
        params do
          requires :friend_id, type: Integer, desc: "Friend id."
          requires :token, type: String, desc: "Access token."
        end
        post do
          authenticate!
          friendship = Friendship.find_by(user: current_user, friend_id: params[:friend_id].to_i)
          if friendship
            create_meetup(friendship)
          else
            error! 'Access Denied', 403
          end
        end

        desc "Accept a meetup"
        params do
          requires :friend_id, type: Integer, desc: "Friend id."
          requires :token, type: String, desc: "Access token."
        end
        post '/accept' do
          authenticate!
          meetup = MeetupRequest.where(
          user_id: params[:friend_id],
          friend_id: current_user.id,
          created_at: (Time.now - 1.hour)..Time.now).last

          if meetup
            if meetup != 'accepted'
              meetup.status = 'accepted'
              if meetup.save
                notify_acceptance(params[:friend_id].to_i, current_user.id)
              else
                error! 'Access Denied', 403
              end
            end
          else
            error! 'Access Denied', 404
          end
        end

        desc "Decline a meetup"
        params do
          requires :friend_id, type: Integer, desc: "Friend id."
          requires :token, type: String, desc: "Access token."
        end
        post '/decline' do
          authenticate!
          meetup = MeetupRequest.where(
          user_id: params[:friend_id],
          friend_id: current_user.id,
          created_at: (Time.now - 1.hour)..Time.now).last

          if meetup
            if meetup.status != "declined"
              meetup.status = 'declined'
              if meetup.save
                notify_refusal(params[:friend_id].to_i, current_user.id)
              else
                error! 'Access Denied'
              end
            end
          else
            error! 'Access Denied', 404
          end
        end

        desc "Terminate a meetup"
        params do
          requires :friend_id, type: Integer, desc: "Friend id."
          requires :token, type: String, desc: "Access token."
        end
        post '/terminate' do
          authenticate!
          meetup = find_meetup(params[:friend_id], current_user.id)

          if meetup
            if meetup.status != "terminated"
              meetup.status = 'terminated'
              meetup.save ? notify_termination(params[:friend_id].to_i, current_user.id) : error!('Access Denied')
            end
          else
            error! 'Access Denied', 404
          end
        end

        desc "Cancel a meetup"
        params do
          requires :friend_id, type: Integer, desc: "Friend id."
          requires :token, type: String, desc: "Access token."
        end
        delete do
          authenticate!
          meetup = find_meetup(params[:friend_id], current_user.id)

          return error!('Access Denied', 404) unless meetup
          if meetup.status == "pending"
            meetup.status = "cancelled"
            error!('Access Denied') unless meetup.save
          end
        end
      end
    end
  end
end
