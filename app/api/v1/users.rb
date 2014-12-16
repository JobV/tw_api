module V1
  class Users < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all

    resource :users do
      desc "Return a user."
      params do
        requires :id, type: Integer, desc: "User id."
      end
      route_param :id do
        get do
          User.find(params[:id])
        end
      end

      desc "Return a list of users."
      get do
        User.all
      end

      desc "Create a new user."
      post do
        User.create!({
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email]
          })
      end
    end
  end
end
