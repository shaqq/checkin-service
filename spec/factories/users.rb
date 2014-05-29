FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "Username #{n}" }
    sequence(:email) { |n| "user_email_#{n}@gmail.com" }
    password 'password'
    password_confirmation 'password'
  end

end
