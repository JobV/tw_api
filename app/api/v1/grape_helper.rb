module V1
  module GrapeHelper
    def user
      User.find(params[:id])
    end
  end
end
