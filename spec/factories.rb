FactoryGirl.define do
  factory :user do
    steam_name "rafer32"
    sequence(:email)      { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      steam_name            "rafer32"
      email                 "user@example.com"
      password              "foobar"
      password_confirmation "foobar"
      admin                 true
    end
  end
end