module V1
  class LocationApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all
    helpers V1::GrapeHelper

    resource :users do
      desc "Get the last known location of the user."
      get ':id/location' do
        loc = user.locations.last
        if loc
          {
            "x" => loc.longlat.x,
            "y" => loc.longlat.y,
            "z" => loc.longlat.z,
            "m" => loc.longlat.m
          }
        else
          {
            "error" => "location not available"
          }
        end
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
