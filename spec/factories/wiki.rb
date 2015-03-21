FactoryGirl.define do
  factory :wiki do
    sequence(:title, 100) { |n| "Title#{n}"}
    body "And this is the wiki's body, a long one."
    user
  end
end