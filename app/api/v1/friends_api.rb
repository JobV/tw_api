module V1
  class FriendsApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all
    helpers V1::GrapeHelper

    resource :users do
      route_param :id do
        resource :friends do
          desc "Return all friends"
          get do
            friends = user.friends.select(
              :first_name,
              :last_name,
              :phone_nr,
              :id,
              :email)
              returning_friends = []
              friends.each do |friend|
                returning_friends << {
                  "first_name" => friend.first_name,
                  "last_name" => friend.last_name,
                  "phone_nr" => friend.phone_nr,
                  "id" => friend.id,
                  "email" => friend.email,
                  "status_with_friend" => get_status_with_friend(user.id, friend.id)
                }
              end
              returning_friends
          end

          desc "Add a friend"
          params do
            requires :phone_nrs, type: Array[String]
          end
          post do
            # Do in a single transaction for minor speed boost.
            ActiveRecord::Base.transaction do
              params[:phone_nrs].each do |phone_nr|
                u = User.find_by(phone_nr: phone_nr)
                user.friends << u if u && !user.friends.exists?(u)
              end
            end
            {
              "total_friends_count" => user.friends.count
            }
          end
        end
        resource :curated_friends do
          desc "Return all friends"
          get do
            user.curated_friends_list
          end
        end
      end
    end
  end
end
