require 'spec_helper'

describe TrendsController do

  describe 'Test after_save' do
    it 'adds 40 votes to the first 4 ideas and 20 to the next 4' do
      10.times do |n|
        i = Idea.new
        i.user_id = rand(1..10)
        i.title = Faker::Name.name
        i.description = Faker::Lorem.paragraph
        i.problem_solved = Faker::Lorem.paragraph
        i.approved = "true"
        i.num_votes = rand(1..500)
        i.save
        v = VoteCount.new
        v.idea = i
        v.prev_day_votes = rand (0..40)
        v.save
      end
      10.times do |n|
        u = User.new
        u.email = Faker::Internet.email
        u.username = Faker::Name.name
        u.password = 123123123
        u.confirm!
        u.save
      end
      4.times do |x|
        40.times do |n|
          u = Vote.new
          u.user_id = n + 1
          u.idea_id = x + 1
          u.save
        end
      end
      4.times do |x|
        20.times do |n|
          u = Vote.new
          u.user_id = n + 1
          u.idea_id = x + 5
          u.save
        end
      end
      trending = Idea.joins(:trend).order('trending desc').limit(4)
      first = trending.first
      first.id.should eq(1)
      second = trending.second
      second.id.should eq(2)
      third = trending.third
      third.id.should eq(3)
      last = trending.last
      last.id.should eq(4)
    end
  end

end
