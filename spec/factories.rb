FactoryGirl.define do  factory :meetup_request, :class => 'MeetupRequests' do
    friendship_id 1
status 1
  end

  factory :friendship do
    user_id 1
    friend_id 1
  end


  factory :location do
    longlat ""
    user_id 1
  end

  factory :user do
    first_name "John"
    last_name  "Doe"
    sequence(:phone_nr) { |n| "0031#{n}618548" }
  end
end
