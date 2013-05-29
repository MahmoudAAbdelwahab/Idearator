require 'spec_helper'

describe HomeController do
  describe 'GET #index' do
    it 'populates 1 idea' do
      idea = Idea.new
      idea.title = "idea1"
      idea.description = "idea"
      idea.problem_solved = "problem"
      idea.save
      get :index, :search => "idea1"
      assigns(:approved).size.should eq(1)
    end
    it 'populates 0 ideas' do
      idea = Idea.new
      idea.title = "idea1"
      idea.description = "idea"
      idea.problem_solved = "problem"
      idea.save
      get :index, :search => "idea23"
      assigns(:approved).size.should eq(0)
    end
  end

  describe "GET index" do

    it "succeeds" do
      get :index
      response.should be_success
    end

    it "returns results page" do
      20.times do
        i = Idea.new
        i.user_id = rand(1..40)
        i.title = Faker::Name.name
        i.description = Faker::Lorem.paragraph
        i.problem_solved = Faker::Lorem.paragraph
        i.approved = "true"
        i.num_votes = rand(1..500)
        i.save
      end
      get :index , :page => 2
      response.should be_success
      assigns(:top).should have(10).items
      assigns(:approved).should have(10).items
    end
  end
end
