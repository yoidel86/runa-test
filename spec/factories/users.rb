FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Name.first_name + '@mail.com' }
    isadmin { true } # only admin can operate login and logout users
    password { Faker::Internet.password(6, 8) }
  end
end
