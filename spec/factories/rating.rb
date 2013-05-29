require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :rating, :class => Rating do |f|
    f.idea_id 1
    f.name 'Rating'
    f.value 0
  end
end
