FactoryBot.define do
  factory :log do
    date { Faker::Date.between('2018-01-01', '2019-02-20') }
    timein { Faker::Time.backward }
    timeout { Faker::Time.backward }
    user_id { nil }
  end
end
