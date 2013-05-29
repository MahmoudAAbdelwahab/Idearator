require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :tag do
    name { Faker::Lorem.word }
  end
end
