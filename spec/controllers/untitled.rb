require 'spec_helper'
include Devise::TestHelpers

RSpec.configure do |config|
  config.mock_framework = :rspec
end

describe 'Twitter Sharing' do
  before :all do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @user.provider = 'facebook'
    @user.save
    @idea = FactoryGirl.create(:idea)
    @idea.user_id = @user.id
    @idea.save
    @facebook_client = Koala::Facebook::API.new
  end

  describe IdeasController do
    describe 'POST create' do
      context 'twitter user wants to create a new idea' do
        before :each do
          Koala::Facebook::API.stub(:new).and_return(@facebook_client)
          Koala::Facebook::API.any_instance.stub(:put_connections).and_return(true)
          sign_in @user
        end

        it 'instantiates a connection with twitter' do
          Koala::Facebook::API.should_receive(:new)
          post :create, :idea => FactoryGirl.attributes_for(:idea_two)
        end
      end
    end
  end
end
