# Mount the parts of the API
# This simply combines the files

module V1
  class API < Grape::API
    mount V1::LocationApi
    mount V1::UsersApi
    mount V1::FriendsApi
    mount V1::MeetupApi
  end
end
