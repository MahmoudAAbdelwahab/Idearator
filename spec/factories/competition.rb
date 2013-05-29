require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :competition do |f|
    f.title Faker::Name.name
    f.description Faker::Lorem.paragraph
    f.start_date 2.days.ago
    f.end_date 8.days.since Time.now.to_date
  end

  factory :notification_competition, :class => Competition do |f|
    f.title 'title'
    f.description 'description competition'
  end

end
