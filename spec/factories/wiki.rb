FactoryGirl.define do
  factory :wiki do
    title "This is a title"
    body "And this is the wiki's body, a long one."
    user
  end
end