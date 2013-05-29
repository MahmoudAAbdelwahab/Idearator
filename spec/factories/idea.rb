require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :idea do |f|
    f.title 'idea1'
    f.description 'description of idea 1'
    f.problem_solved 'problem solved of idea 1'
  end

  factory :idea_two, parent: :idea do |f|
    f.title 'idea2'
  end

  factory :invalid_idea, parent: :idea do |f|
    f.title nil
  end
end