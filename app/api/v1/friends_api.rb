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
            current_user.friends
          end
        end
      end
    end
  end
end
