require 'spec_helper'

describe CommitteesController do
  describe 'PUT archive' do
    include Devise::TestHelpers


    describe "review_ideas"
    it "renders unapproved ideas with the area of expertise of the committee member" do
      @committee=Committee.new
      @committee.email='c@gmail.com'
      @committee.password=123123123
      @committee.username='c'
      @committee.confirm!
      @committee.save
      @idea=Idea.new
      @idea.title='bla'
      @idea.problem_solved='bla'
      @idea.description='bla'
      @idea.save
      @tag=Tag.new
      @tag.name='t1'
      @tag.save
      @committee.tags << @tag
      @idea.tags << @tag
      sign_in(@committee)
      get :review_ideas
      assigns(:ideas).should ==[@idea]
    end
    it "doesnt render unapproved ideas with diffrent area of expertise of the committee member" do
      @committee=Committee.new
      @committee.email='c@gmail.com'
      @committee.password=123123123
      @committee.username ='c'
      @committee.confirm!
      @committee.save
      @idea=Idea.new
      @idea.title='bla'
      @idea.problem_solved='bla'
      @idea.description='bla'
      @idea.save
      @tag=Tag.new
      @tag.name='t1'
      @tag.save
      @committee.tags << @tag
      sign_in(@committee)
      get :review_ideas
      assigns(:ideas).should ==[]
    end
    it "doesnt render approved ideas with diffrent area of expertise of the committee member" do
      @committee=Committee.new
      @committee.email='c@gmail.com'
      @committee.password=123123123
      @committee.username='c'
      @committee.confirm!
      @committee.save
      @idea=Idea.new
      @idea.title='bla'
      @idea.problem_solved='bla'
      @idea.description='bla'
      @idea.approved=true
      @idea.save
      @tag=Tag.new
      @tag.name='t1'
      @tag.save
      @committee.tags << @tag
      sign_in(@committee)
      get :review_ideas
      assigns(:ideas).should ==[]
    end
  end
  describe "disapprove" do
    it "changes the approved status of the idea" do
      @user=User.new
      @user.email='x@gmail.com'
      @user.password=123123123
      @user.confirm!
      @user.save
      @committee=Committee.new
      @committee.email='c@gmail.com'
      @committee.password=123123123
      @committee.username='c'
      @committee.confirm!
      @committee.save
      @idea=Idea.new
      @idea.title='bla'
      @idea.problem_solved='bla'
      @idea.description='bla'
      @idea.save
      @idea.user=@user
      @idea.approved=true
      @idea.save
      sign_in(@committee)
      get :disapprove, :id => @idea.id
      @idea.reload
      (@idea.approved).should eql(false)
    end
  end
  describe "add_rating" do
    it "approves the idea" do
      @committee=Committee.new
      @committee.email='c@gmail.com'
      @committee.password=123123123
      @committee.username='c'
      @committee.confirm!
      @committee.save @idea=Idea.new
      @idea.title='bla'
      @idea.problem_solved='bla'
      @idea.description='bla'
      @idea.save
      session[:idea_id]=@idea.id
      sign_in(@committee)
      get :add_prespectives , :id => @idea.id
      @idea.reload
      (@idea.approved).should eql(true)
    end
    it "add rating prespectives to the idea" do
      @committee=Committee.new
      @committee.email='c@gmail.com'
      @committee.password=123123123
      @committee.username='c'
      @committee.confirm!
      @committee.save @idea=Idea.new
      @idea.title='bla'
      @idea.problem_solved='bla'
      @idea.description='bla'
      @idea.save
      session[:idea_id]=@idea.id
      sign_in(@committee)
      get :add_rating , :id => @idea.id, :rating => ['ay 7aga']
      @idea.reload
      (@idea.ratings.count).should eql(1)
    end
  end
end
#end
