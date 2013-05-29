require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :comment, :class => Comment do |f|
    f.user_id 1
    f.idea_id 1
    f.content 'comment'
  end
end
