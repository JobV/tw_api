module V1
  class FriendsApi < Grape::API
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
        resource :friends do
          desc "Return all friends"
          get do
            current_user.friends.select(
              :first_name,
              :last_name)
          end

          desc "Add a friend"
          params do
            requires :phone_nrs, type: Array[String]
          end
          post do
            # Do in a single transaction for minor speed boost.
            ActiveRecord::Base.transaction do
              params[:phone_nrs].each do |phone_nr|
                if u = User.find_by(phone_nr: phone_nr)
                  current_user.friends << u
                end
              end
            end
          end
        end
      end
    end
  end
end