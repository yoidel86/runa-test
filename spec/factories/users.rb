
FactoryBot.define do
  factory :user do
    nm = Faker::Name.first_name
    name { nm }
    email { nm+"@mail.com"}
    password {Faker::Lorem.word}
  end
end