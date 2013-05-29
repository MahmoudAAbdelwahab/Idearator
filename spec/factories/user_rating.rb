require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :user_rating, :class => UserRating do |f|
    f.value 5
  end
end