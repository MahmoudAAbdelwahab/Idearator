require 'spec_helper'

describe UserRatingsController do
  describe 'POST create' do
    include Devise::TestHelpers

    context 'user wants to rate an idea' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
       	@rating = FactoryGirl.create(:rating)
        @rating.idea_id = @idea.id
        @rating.save
        sign_in @user
      end

      it 'creates the rating' do
        expect { post :create, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 5 } }.to change(UserRating, :count).by(1)
      end
    end
  end

  describe 'PUT update' do
    include Devise::TestHelpers

    context 'user wants to update his rating' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
       	@rating = FactoryGirl.create(:rating)
        @rating.idea_id = @idea.id
        @rating.save
        @user_rating = FactoryGirl.create(:user_rating)
        @user_rating.rating_id = @rating.id
        @user_rating.user_id = @user.id
        @user_rating.save
        sign_in @user
      end

      it 'updates the rating' do
        @val = @user_rating.value
        put :update, :idea_id => @idea.id, :rating_id => @rating.id, :rating => { :value => 3 }
        @user_rating.reload
        (@user_rating.value).should_not eql(@val)
      end
    end
  end
end