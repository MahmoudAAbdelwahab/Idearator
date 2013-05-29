require 'spec_helper'

describe UserRatingsHelper do
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

  describe 'rating ballot' do
    include Devise::TestHelpers
    
    context 'user wants to rate an idea' do
      it 'returns an existing rating ballot' do
      	((helper.rating_ballot(@rating.id)).rating_id).should eql(@rating.id)
      end

      it 'returns a new rating ballot' do
      	@user_rating.destroy
        (helper.rating_ballot(@rating.id)).should be_an_instance_of(UserRating)
      end
    end
  end

  describe 'current user rating' do
    include Devise::TestHelpers
    
    context 'user wants to view his rating' do
      it 'returns current rating value if any' do
        (helper.current_user_rating(@rating.id)).should eql(@user_rating.value)
      end

      it 'returns N/A if no current rating value is available' do
        @user_rating.destroy
        (helper.current_user_rating(@rating.id)).should eql('N/A')
      end
    end
  end
end