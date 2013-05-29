require 'spec_helper'
include Devise::TestHelpers

RSpec.configure do |config|
  config.mock_framework = :rspec
end

describe 'Twitter Sharing' do
  before :all do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @user.provider = 'twitter'
    @user.save
    @idea = FactoryGirl.create(:idea)
    @idea.user_id = @user.id
    @idea.save
    @twitter_client = Twitter::Client.new
  end

  describe IdeasController do
    describe 'POST create' do
      context 'twitter user wants to create a new idea' do
        context 'with sharing option applied' do
          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with twitter' do
            Twitter::Client.should_receive(:new)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end

          it 'updates his twitter status' do
            Twitter::Client.any_instance.should_receive(:update)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end
        end

        context 'with sharing option not applied' do
          before :all do
            @user.facebook_share = false
            @user.save
          end

          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'does not fetch Twitter Client' do
            User.any_instance.should_not_receive(:twitter)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end

          it 'does not instantiate a connection with twitter' do
            Twitter::Client.should_not_receive(:new)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end

          it 'does not update his twitter status' do
            Twitter::Client.any_instance.should_not_receive(:update)
            post :create, :idea => FactoryGirl.attributes_for(:idea_two)
          end

          after :all do
            @user.facebook_share = true
            @user.save
          end
        end
      end
    end

    describe 'PUT vote' do
      context 'twitter user wants to vote to any idea' do
        context 'with sharing option applied' do
          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with twitter' do
            Twitter::Client.should_receive(:new)
            put :vote, :id => @idea.id
          end

          it 'updates his twitter status' do
            Twitter::Client.any_instance.should_receive(:update)
            put :vote, :id => @idea.id
          end
        end

        context 'with sharing option not applied' do
          before :all do
            @user.facebook_share = false
            @user.save
          end

          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'does not fetch Twitter Client' do
            User.any_instance.should_not_receive(:twitter)
            put :vote, :id => @idea.id
          end

          it 'does not instantiate a connection with twitter' do
            Twitter::Client.should_not_receive(:new)
            put :vote, :id => @idea.id
          end

          it 'does not update his twitter status' do
            Twitter::Client.any_instance.should_not_receive(:update)
            put :vote, :id => @idea.id
          end

          after :all do
            @user.facebook_share = true
            @user.save
          end
        end
      end
    end

    describe 'PUT update' do
      context 'twitter user wants to update his idea' do
        context 'with sharing option applied' do
          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with twitter' do
            Twitter::Client.should_receive(:new)
            put :update, :id => @idea.id
          end

          it 'updates his twitter status' do
            Twitter::Client.any_instance.should_receive(:update)
            put :update, :id => @idea.id
          end
        end

        context 'with sharing option not applied' do
          before :all do
            @user.facebook_share = false
            @user.save
          end

          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'does not fetch Twitter Client' do
            User.any_instance.should_not_receive(:twitter)
            put :update, :id => @idea.id
          end

          it 'does not instantiate a connection with twitter' do
            Twitter::Client.should_not_receive(:new)
            put :update, :id => @idea.id
          end

          it 'does not update his twitter status' do
            Twitter::Client.any_instance.should_not_receive(:update)
            put :update, :id => @idea.id
          end

          after :all do
            @user.facebook_share = true
            @user.save
          end
        end
      end
    end

    describe 'PUT unarchive' do
      before :all do
        @idea.archive_status = true
        @idea.save
      end

      context 'twitter user wants to unarchive his idea' do
        context 'with sharing option applied' do
          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with twitter' do
            Twitter::Client.should_receive(:new)
            put :unarchive, :id => @idea.id, :format => 'js'
          end

          it 'updates his twitter status' do
            Twitter::Client.any_instance.should_receive(:update)
            put :unarchive, :id => @idea.id, :format => 'js'
          end
        end

        context 'with sharing option not applied' do
          before :all do
            @user.facebook_share = false
            @user.save
          end

          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'does not fetch Twitter Client' do
            User.any_instance.should_not_receive(:twitter)
            put :unarchive, :id => @idea.id, :format => 'js'
          end

          it 'does not instantiate a connection with twitter' do
            Twitter::Client.should_not_receive(:new)
            put :unarchive, :id => @idea.id, :format => 'js'
          end

          it 'does not update his twitter status' do
            Twitter::Client.any_instance.should_not_receive(:update)
            put :unarchive, :id => @idea.id, :format => 'js'
          end

          after :all do
            @user.facebook_share = true
            @user.save
          end
        end
      end

      after :all do
        @idea.archive_status = false
        @idea.save
      end
    end
  end

  describe UserRatingsController do
    before :all do
      @rating = FactoryGirl.create(:rating)
      @rating.idea_id = @idea.id
      @rating.save
    end

    describe 'POST create' do
      context 'twitter user wants to rate idea' do
        context 'with sharing option applied' do
          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'instantiates a connection with twitter' do
            Twitter::Client.should_receive(:new)
            post :create, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 5 }
          end

          it 'updates his twitter status' do
            Twitter::Client.any_instance.should_receive(:update)
            post :create, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 5 }
          end
        end

        context 'with sharing option not applied' do
          before :all do
            @user.facebook_share = false
            @user.save
          end

          before :each do
            Twitter::Client.stub(:new).and_return(@twitter_client)
            Twitter::Client.any_instance.stub(:update).and_return(true)
            sign_in @user
          end

          it 'does not fetch Twitter Client' do
            User.any_instance.should_not_receive(:twitter)
            post :create, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 5 }
          end

          it 'does not instantiate a connection with twitter' do
            Twitter::Client.should_not_receive(:new)
            post :create, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 5 }
          end

          it 'does not update his twitter status' do
            Twitter::Client.any_instance.should_not_receive(:update)
            post :create, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 5 }
          end

          after :all do
            @user.facebook_share = true
            @user.save
          end
        end
      end
    end
  end

  after :all do
    @idea.destroy
    @user.destroy
  end
end
