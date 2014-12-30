module V1
  class UsersApi < Grape::API
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
      params do
        requires :first_name, type: String, desc: "First name."
        requires :last_name, type: String, desc: "Last name."
        requires :email, type: String, desc: "Email."
        requires :phone_nr, type: String, desc: "Phone nr."
      end
      post do
        User.create!({
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email],
          phone_nr: params[:phone_nr]
          })
      end

      desc "Update a user."
      params do
        requires :id, type: String, desc: "User id."
      end
      put ':id' do
        User.find(params[:id]).update({
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email]
          })
      end

      desc "Delete a user."
      params do
        requires :id, type: String, desc: "User id."
      end
      delete ':id' do
        User.find(params[:id]).destroy!
      end
    end
  end
end
