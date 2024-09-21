FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    after(:create) do |user|
      user.image.attach(io: File.open('spec/fixtures/files/profile.png'), filename: 'profile.png', content_type: 'image/png')
    end
  end
end