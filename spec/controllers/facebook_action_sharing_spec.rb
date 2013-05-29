require 'spec_helper'
include Devise::TestHelpers

# RSpec.configure do |config|
#   config.mock_framework = :rspec
# end

describe 'Facebook Sharing' do
  before :all do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @user.provider = 'facebook'
    @user.save
    @idea = FactoryGirl.build(:idea)
    @idea.user_id = @user.id
    @idea.save
    @facebook_client = Koala::Facebook::API.new
  end

  describe IdeasController do
    describe 'POST create' do
      context 'facebook user wants to create a new idea' do
        context 'with sharing option applied' do

          before :each do
            Koala::Facebook::API.stub(:new).and_return(@facebook_client)
            Koala::Facebook::API.any_instance.stub(:put_connections).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with facebook' do
            Koala::Facebook::API.should_receive(:new)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end

          it 'updates his facebook wall' do
            Koala::Facebook::API.any_instance.should_receive(:put_connections)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end
        end

        context 'with sharing option applied' do
          before :each do
            @user.facebook_share = false
            @user.save
            Koala::Facebook::API.stub(:new).and_return(@facebook_client)
            Koala::Facebook::API.any_instance.stub(:put_connections).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with facebook' do
            Koala::Facebook::API.should_not_receive(:new)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end

          it 'updates his facebook wall' do
            Koala::Facebook::API.any_instance.should_not_receive(:put_connections)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end
        end
      end
    end

    describe 'PUT vote' do
      context 'facebook user wants to vote for an idea' do
        context 'with sharing option applied' do

          before :each do
            @user.facebook_share = true
            @user.save
            Koala::Facebook::API.stub(:new).and_return(@facebook_client)
            Koala::Facebook::API.any_instance.stub(:put_connections).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with facebook' do
            Koala::Facebook::API.should_receive(:new)
            put :vote, :id => @idea.id
          end

          it 'updates his facebook wall' do
            Koala::Facebook::API.any_instance.should_receive(:put_connections)
            put :vote, :id => @idea.id
          end
        end

        context 'with sharing option applied' do
          before :each do
            @user.facebook_share = false
            @user.save
            Koala::Facebook::API.stub(:new).and_return(@facebook_client)
            Koala::Facebook::API.any_instance.stub(:put_connections).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with facebook' do
            Koala::Facebook::API.should_not_receive(:new)
            put :vote, :id => @idea.id
          end

          it 'updates his facebook wall' do
            Koala::Facebook::API.any_instance.should_not_receive(:put_connections)
            put :vote, :id => @idea.id
          end
        end
      end
    end
  end
  after :all do
    @user.destroy
    @idea.destroy
  end
end
