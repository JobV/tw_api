module V1
  class FriendsApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all
    helpers V1::GrapeHelper

    resource :users do
      resource :friends do
        desc "Return all friends"
        params do
          requires :token, type: String, desc: "Access token."
        end
        get do
          authenticate!
          friends = current_user.friends.select(
          :first_name,
          :last_name,
          :phone_nr,
          :id,
          :email,
          :provider,
          :provider_id)
          returning_friends = []
          friends.each do |friend|
            returning_friends << {
              "first_name" => friend.first_name,
              "last_name" => friend.last_name,
              "phone_nr" => friend.phone_nr,
              "id" => friend.id,
              "email" => friend.email,
              "status_with_friend" => get_status_with_friend(current_user.id, friend.id),
              "provider" => friend.provider,
              "provider_id" => friend.provider_id
            }
          end
          returning_friends
        end

        desc "Add a friend"
        params do
          requires :token, type: String, desc: "Access token."
          requires :phone_nrs, type: Array[String]
        end
        post do
          authenticate!
          ActiveRecord::Base.transaction do
            params[:phone_nrs].each do |phone_nr|
              u = User.find_by(phone_nr: phone_nr)
              current_user.friends << u if u && !current_user.friends.exists?(u)
            end
          end
          {
            "total_friends_count" => current_user.friends.count
          }
        end
      end

      resource :curated_friends do
        desc "Return all friends"
        params do
          requires :token, type: String, desc: "Access token."
        end
        get do
          authenticate!
          current_user.curated_friends_list
        end
      end
    end
  end
end
