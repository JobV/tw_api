module V1
  class UsersApi < Grape::API
    include GrapeHelper
    version 'v1'
    format :json
    prefix :api
    rescue_from :all
    helpers V1::GrapeHelper

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
      end
      post do
        User.create!({
          first_name: params[:first_name],
          last_name: params[:last_name],
          email: params[:email]
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

      desc "Get the last known location of the user."
      get ':id/location' do
        loc = user.locations.last
        {
          "x" => loc.longlat.x,
          "y" => loc.longlat.y,
          "z" => loc.longlat.z,
          "m" => loc.longlat.m
        }
      end

      desc "Set the location of the user."
      params do
        requires :x, type: String, desc: "X coordinate."
        requires :y, type: String, desc: "Y coordinate."
        optional :z, type: String, desc: "Z coordinate."
        optional :m, type: String, desc: "M coordinate."
      end
      post ':id/location' do
        user.locations.create!(
        longlat: "POINT(#{params[:x]}
        #{params[:y]}
        #{params[:z]}
        #{params[:m]})")
      end
    end
  end
end
