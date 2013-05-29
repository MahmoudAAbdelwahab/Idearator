require 'spec_helper'
describe UsersController do
  include Devise::TestHelpers
  describe "responding to GET show" do
    before(:each) do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      sign_in @user
    end
    it "should expose the requested user as @user and render [show] template" do
      @new_user = FactoryGirl.build(:user_two)
      @new_user.confirm!
      get :show, :id => @new_user.id
      assigns[:user].should == @new_user
      response.should render_template("users/show")
    end
  end
  describe "PUT 'update'" do
    before(:each) do
      @user = FactoryGirl.build(:user)
      @user.first_name = 'first_name'
      @user.last_name = 'last_name'
      @user.username = 'username'
      @user.date_of_birth = Date.current()
      @user.confirm!
      sign_in @user
    end
    it "should change the user's attributes" do
      @attr = { :first_name => 'first_name_updated', :last_name => 'last_name_updated', :username => 'username_updated' }
      puts 'Old first_name: ' + @user.first_name
      put :update, :id => @user, :user => @attr
      @user.reload
      (@user.first_name).should eql('first_name_updated')
      (@user.last_name).should eql('last_name_updated')
      (@user.username).should eql('username_updated')
      puts 'New first_name: ' + @user.first_name
    end
  end
  describe 'GET ideas' do
    it 'views an idea stream for a certain user' do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      @idea = FactoryGirl.create(:idea)
      @idea.approved = true
      @idea.user = @user
      @idea.save
      sign_in @user
      get :ideas, :id => @user.id
      response.should render_template("users/ideas")
      assigns(:ideas).size.should eq(1)
    end
  end
  describe 'Get profile_modal' do
    it 'views a modal profile for a specific user' do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      sign_in @user
      get :profile_modal, :id => @user.id
      response.should render_template("users/profile_modal")
      assigns(:selected_user).should eq(@user)
    end
  end
  describe "PUT change_settings" do
    it "changes user settings" do
      u= User.new
      u.email="test1@gmail.com"
      u.username= "sameh"
      u.password= "123123123"
      u.confirm!
      u.save
      sign_in u
      put :change_settings, :user=> ['1']
      u.reload
      u.own_idea_notifications.should eq(true)
      u.participated_idea_notifications.should eq(false)
    end
    it "changes user settings" do
      u1= User.new
      u1.email="test1@gmail.com"
      u1.username= "sameh"
      u1.password= "123123123"
      u1.confirm!
      u1.save
      sign_in u1
      put :change_settings, :user=> []
      u1.reload
      u1.own_idea_notifications.should eq(false)
      u1.participated_idea_notifications.should eq(false)
    end
  end
  before :each do
    @a = Admin.new
    @a.email = 'admin@gmail.com'
    @a.username = 'admin'
    @a.password = '123123123'
    @a.confirm!
    @a.save
    sign_in @a

    @u1 = User.new
    @u1.email = 'user1@gmail.com'
    @u1.username = 'user1'
    @u1.password = '123123123'
    @u1.confirm!
    @u1.save
  end
  describe "PUT #invite_member" do
    it "retrieves the user instance from :id" do
      put :invite_member, :id => @u1.id
      assigns(:user).should eq(@u1)
    end
    it "inititates the user to the committees table" do
      put :invite_member, :id => @u1.id
      @u1.reload
      @u1.type.should eq("Committee")
    end
    it "calls InviteCommitteeNotification.send_notification(Admin, User)" do
      expect{ put :invite_member, :id => @u1.id }.to change(InviteCommitteeNotification,:count).by(1)
    end
    it "redirects to home page" do
      put :invite_member, :id => @u1.id
      response.should redirect_to '/'
    end
  end
end
