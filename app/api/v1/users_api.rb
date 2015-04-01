module V1
  class UsersApi < Grape::API
    helpers ApnsHelper
    version 'v1'
    format :json
    prefix :api
    rescue_from :all
    helpers V1::GrapeHelper

    resource :users do
      desc "Return a user."
      params do
        requires :id, type: Integer, desc: "User id."
        requires :token, type: String, desc: "Access token."
      end
      route_param :id do
        get do
          authenticate!
          current_user
        end
      end

      desc "Create a new user."
      params do
        requires :first_name, type: String, desc: "First name."
        requires :last_name, type: String, desc: "Last name."
        requires :email, type: String, desc: "Email."
        requires :phone_nr, type: String, desc: "Phone nr."
      end
      post do
        User.create!(
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email],
          phone_nr: params[:phone_nr]
          )
      end
    end
  end
end
