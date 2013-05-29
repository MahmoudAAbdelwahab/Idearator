require 'spec_helper'

describe IdeasController do

  describe 'Post Filter' do

    # tests multitag filtering
    # Author: muhammed hassan
    it 'filters on multiple tags' do
      i = Idea.new
      i.user_id = rand(1..40)
      i.title = Faker::Name.name
      i.description = Faker::Lorem.paragraph
      i.problem_solved = Faker::Lorem.paragraph
      i.approved = 'true'
      i.num_votes = rand(1..500)
      i.save
      i2 = Idea.new
      i2.user_id = rand(1..40)
      i2.title = Faker::Name.name
      i2.description = Faker::Lorem.paragraph
      i2.problem_solved = Faker::Lorem.paragraph
      i2.approved = 'true'
      i2.num_votes = rand(1..500)
      i2.save
      i3 = Idea.new
      i3.user_id = rand(1..40)
      i3.title = Faker::Name.name
      i3.description = Faker::Lorem.paragraph
      i3.problem_solved = Faker::Lorem.paragraph
      i3.approved = 'true'
      i3.num_votes = rand(1..500)
      i3.save
      t = Tag.new
      t.name = Faker::Name.name
      t.save
      t2 = Tag.new
      t2.name = Faker::Name.name
      t2.save
      it = IdeasTags.new
      it.idea_id = 1
      it.tag_id = 1
      it.save
      it2 = IdeasTags.new
      it2.idea_id = 2
      it2.tag_id = 2
      it2.save
      post :filter, :myTags => [t.name, t2.name]
      assigns(:approved).should have(2).items
    end

    # tests rendered json
    # Author: muhammed hassan
    it 'renders ideas as json' do
      i = Idea.new
      i.user_id = rand(1..40)
      i.title = Faker::Name.name
      i.description = Faker::Lorem.paragraph
      i.problem_solved = Faker::Lorem.paragraph
      i.approved = 'true'
      i.num_votes = rand(1..500)
      i.save
      t = Tag.new
      t.name = Faker::Name.name
      t.save
      it = IdeasTags.new
      it.idea_id = 1
      it.tag_id = 1
      it.save
      post :filter, :myTags => [t.name] , :format => :json
      response.body.should == assigns(:approved).to_json
    end

    # tests rendered js file
    # Author: muhammed hassan
    it 'renders js file' do
      i = Idea.new
      i.user_id = rand(1..40)
      i.title = Faker::Name.name
      i.description = Faker::Lorem.paragraph
      i.problem_solved = Faker::Lorem.paragraph
      i.approved = 'true'
      i.num_votes = rand(1..500)
      i.save
      t = Tag.new
      t.name = Faker::Name.name
      t.save
      it = IdeasTags.new
      it.idea_id = 1
      it.tag_id = 1
      it.save
      post :filter, :myTags => [t.name] , :format => :js
      response.should be_success
    end

  end

end
