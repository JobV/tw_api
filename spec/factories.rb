FactoryGirl.define do
  factory :api_key do
    access_token "MyString"
    expires_at "2015-04-01 12:47:48"
    user_id 1
    active false
  end

  factory :meetup_request do
    friendship_id 1
    status 1
  end

  factory :friendship do
    user_id 1
    friend_id 2
  end

  factory :location do
    longlat ""
    user_id 1
  end

  factory :user do
    first_name "John"
    last_name "Doe"
    sequence(:phone_nr) { |n| "0031#{n}618548" }
  end

  factory :device do
    sequence(:token) { |n| "123456789#{n}" }
    name "iPhone"
    os "iOS 8.1.3"
  end
end
