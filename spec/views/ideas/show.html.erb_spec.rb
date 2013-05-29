require 'spec_helper'

describe 'ideas/show.html.erb' do
  include Devise::TestHelpers

  before :all do
    @user = FactoryGirl.build(:user)
    @user.confirm!
    @idea = FactoryGirl.create(:idea)
    @idea.user_id = @user.id
    @idea.save
  end

  context 'if idea is not archived' do
    before :each do
      render :template => '/ideas/show', :locals => { :idea => @idea }
    end

    it 'has a pinterest image' do
      rendered.should have_tag('img#pin', :visible => true)
    end

    it 'has a facebook image' do
      rendered.should have_tag('img#fbk', :visible => true)
    end

    it 'has a twitter image' do
      rendered.should have_tag('img#tw', :visible => true)
    end

    it 'has facebook comments' do
      rendered.should have_tag('div.fb-comments', :visible => true)
    end
  end

  context 'if idea is archived' do
    before :all do
      @idea.archive_status = true
      @idea.save
    end

    before :each do
      render :template => '/ideas/show', :locals => { :idea => @idea }
    end

    it 'has a hidden pinterest image' do
      rendered.should have_tag('img#pin', :visible => false)
    end

    it 'has a hidden facebook image' do
      rendered.should have_tag('img#fbk', :visible => false)
    end

    it 'has a hidden twitter image' do
      rendered.should have_tag('img#tw', :visible => false)
    end

    it 'has hidden facebook comments' do
      rendered.should have_tag('div.fb-comments', :visible => false)
    end
  end

  after :all do
    @user.destroy
    @idea.destroy
  end
end