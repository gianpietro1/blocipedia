FactoryGirl.define do
  factory :user do
    name "UserFirst UserLast"
    sequence(:email, 100) { |n| "firstlast#{n}@example.com" }
    password "helloworld"
    password_confirmation "helloworld"
    confirmed_at Time.now
  end
end