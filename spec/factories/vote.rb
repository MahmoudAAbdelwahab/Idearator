require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :vote, :class => Vote do |f|
    f.user_id 1
    f.idea_id 1
  end
end