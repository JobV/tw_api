module V1
  class LocationApi < Grape::API
    version 'v1'
    format :json
    prefix :api
    rescue_from :all

    before do
      puts "============="
      puts params
      puts "============="
    end

    helpers do
      def user
        User.find(params[:id])
      end
    end

    resource :location do
      desc "Set the location of the user."
      params do
        requires :id, type: Integer, desc: "User id."
        requires :x, type: String, desc: "X coordinate."
        requires :y, type: String, desc: "Y coordinate."
        optional :z, type: String, desc: "Z coordinate."
        optional :m, type: String, desc: "M coordinate."
      end
      post do
        user.locations.create!(
          longlat: "POINT(#{params[:x]}
                          #{params[:y]}
                          #{params[:z]}
                          #{params[:m]})")

      end

      desc "Get the last location of the user."
      params do
        requires :id, type: Integer, desc: "User id."
      end
      route_param :id do
        get do
          loc = user.locations.last
          {
            "x" => loc.longlat.x,
            "y" => loc.longlat.y,
            "z" => loc.longlat.z,
            "m" => loc.longlat.m
          }
        end
      end
    end
  end
end
