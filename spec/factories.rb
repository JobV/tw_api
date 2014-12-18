FactoryGirl.define do

  factory :location do
    longlat ""
    user_id 1
  end

  factory :user do
    first_name "John"
    last_name  "Doe"
  end
end
