FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.word[0..1] + Faker::Lorem.word }
  end
end
