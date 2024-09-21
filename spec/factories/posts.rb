FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    association :user
    after(:build) do |post|
      post.tags << create(:tag)
    end
  end
end