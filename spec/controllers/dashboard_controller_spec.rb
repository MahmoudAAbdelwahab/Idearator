require 'spec_helper'
include Devise::TestHelpers

describe DashboardController do
  describe 'Get index' do
    before :each do
        @user = Committee.create(email: 'test@test.com', password: 123123123)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.approved = true
        @idea.committee = @user
        @idea.user = @user
        @idea.save
        @idea_2 = FactoryGirl.create(:idea)
        @idea_2.approved = true
        @idea_2.committee = @user
        @idea_2.user = @user
        @idea_2.save
        VoteCount.create(:idea_id => @idea.id)
        VoteCount.create(:idea_id => @idea_2.id)
        @threshold = Threshold.create(:threshold => 50)
        sign_in @user
    end
    it 'gets own ideas for the current user' do
      get :index
      assigns(:own_ideas).should have(2).items
    end

    it 'gets approved ideas for the committee member' do
      get :index
      assigns(:approved_ideas).should have(2).items
    end
    it 'gets current threshold' do
      get :index
      assigns(:threshold).threshold.should eq(50)
    end
    it 'gets previous day vote count of ideas' do
      get :index
      assigns(:own_thresholds).should have(2).items
    end
  end

  describe 'GET #gettags' do
    it 'populates one tags' do
      idea = Idea.new
      idea.title = "title"
      idea.problem_solved = "problem"
      idea.description = "description"
      idea.save
      idea1 = Idea.new
      idea1.title = "title"
      idea1.problem_solved = "problem"
      idea1.description = "description"
      idea1.save
      tag = Tag.new
      tag.name = "tag"
      tag.save
      tag1 = Tag.new
      tag1.name = "tag"
      tag1.save
      it = IdeasTags.new
      it.idea_id = idea.id
      it.tag_id = tag.id
      it.save
      it1 = IdeasTags.new
      it1.idea_id = idea.id
      it1.tag_id = tag1.id
      it1.save
      get :gettags, :ideaid => idea.id
      assigns(:ideatags).size.should eq(2)
    end
     it 'populates 0 tags' do
      idea = Idea.new
      idea.title = "title"
      idea.problem_solved = "problem"
      idea.description = "description"
      idea.save
      idea1 = Idea.new
      idea1.title = "title"
      idea1.problem_solved = "problem"
      idea1.description = "description"
      idea1.save
      tag = Tag.new
      tag.name = "tag"
      tag.save
      tag1 = Tag.new
      tag1.name = "tag"
      tag1.save
      it = IdeasTags.new
      it.idea_id = idea.id
      it.tag_id = tag.id
      it.save
      it1 = IdeasTags.new
      it1.idea_id = idea.id
      it1.tag_id = tag1.id
      it1.save
      get :gettags, :ideaid => idea1.id
      assigns(:ideatags).size.should eq(0)
    end
  end

  describe 'GET #chart_data' do
   it 'returns chart  ' do
     l=User.new
     l.email = "lina@gmail.com"
     l.password = "123123123"
      l.first_name = "lina"
      l.confirm!
      l.save
      tag = Tag.new
      tag.name = "tag"
      tag.save
      sign_in l
      i = Idea.new
      i.user_id = l.id
      i.title = Faker::Name.name
      i.description = Faker::Lorem.paragraph
      i.problem_solved = Faker::Lorem.paragraph
      i.approved = 'true'
      i.num_votes = rand(1..500)
      i.save
      tagidea = IdeasTags.new
      tagidea.tag_id = tag.id
      tagidea.idea_id = i.id
      tagidea.save

      20.times do
       i = Idea.new
       i.title = Faker::Name.name
        i.description = Faker::Lorem.paragraph
        i.problem_solved = Faker::Lorem.paragraph
        i.approved = 'true'
        i.num_votes = rand(1..500)
        i.save

        tagidea = IdeasTags.new
        tagidea.tag_id = tag.id
        tagidea.idea_id = i.id
        tagidea.save
      end
      get :chart_data, :tag_id => tag.id
      assigns(:user_ideas).size.should eq(1)
      assigns(:ideasall).size.should eq(20)
    end
  end
end