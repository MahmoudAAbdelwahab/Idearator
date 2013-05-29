require 'spec_helper'

describe Competition do
  before :each do
    @competition1 = FactoryGirl.create(:competition, start_date: Time.now.to_date + 1.day)
    @competition2 = FactoryGirl.create(:competition, end_date: 2.days.ago)
    @competition3 = FactoryGirl.create(:competition)
  end

  it "has a valid factory" do
    FactoryGirl.create(:competition).should be_valid
  end

  it "checks open competitions" do
    @competition1.open.should  == false
    @competition2.open.should  == false
    @competition3.open.should  == true
  end
end