require 'spec_helper'

describe NotificationsController do
  include Devise::TestHelpers

  before :each do
    @idea = FactoryGirl.create(:idea)
    @competition = FactoryGirl.create(:notification_competition)
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
    @vote_notification = FactoryGirl.create(:vote_notification)
    @vote_notification.idea = @idea
    @vote_notification.user = @user
    @vote_notification.users = [@user]
    @vote_notification.save
    @invite_committee_notification = FactoryGirl.create(:invite_committee_notification)
    @invite_committee_notification.user = @user
    @invite_committee_notification.users = [@user]
    @invite_committee_notification.save
    @approve_committee_notification = FactoryGirl.create(:approve_committee_notification)
    @approve_committee_notification.user = @user
    @approve_committee_notification.users = [@user]
    @approve_committee_notification.save
    @delete_notification = FactoryGirl.create(:delete_notification)
    @delete_notification.idea = @idea
    @delete_notification.user = @user
    @delete_notification.users = [@user]
    @delete_notification.save
    @create_competition_notification = FactoryGirl.create(:create_competition_notification)
    @create_competition_notification.user = @user
    @create_competition_notification.competition = @competition
    @create_competition_notification.users = [@user]
    @create_competition_notification.save
    @enter_idea_notification = FactoryGirl.create(:enter_idea_notification)
    @enter_idea_notification.user = @user
    @enter_idea_notification.competition = @competition
    @enter_idea_notification.idea = @idea
    @enter_idea_notification.users = [@user]
    @enter_idea_notification.save
  end
  describe 'GET view_all_notifications' do

    it 'redirects to all notifications view' do

      get :view_all_notifications
      response.should render_template('view_all_notifications')

    end
  end

  describe 'PUT redirect_idea' do
    it 'assigns the read value to true' do
      put :redirect_idea, :notification => @vote_notification.id
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @vote_notification.id, user_id: @user.id })
      notification_user.read.should eq(true)
    end
  end

  describe 'PUT redirect_expertise' do
    it 'assigns the read value to true' do
      put :redirect_expertise, :notification => @invite_committee_notification.id
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @invite_committee_notification.id, user_id: @user.id })
      notification_user.read.should eq(true)
    end
  end

  describe 'PUT redirect_review' do
    it 'assigns the read value to true' do
      put :redirect_review, :notification => @approve_committee_notification.id
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @approve_committee_notification.id, user_id: @user.id })
      notification_user.read.should eq(true)
    end
  end

  describe 'PUT set_read' do
    it 'assigns the read value to true' do
      put :set_read, :notification => @delete_notification.id
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @delete_notification.id, user_id: @user.id })
      notification_user.read.should eq(true)
    end
  end

  describe 'PUT redirect_competition' do
    it 'assigns the read value to true' do
      put :redirect_competition, :notification => @create_competition_notification.id
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @create_competition_notification.id, user_id: @user.id })
      notification_user.read.should eq(true)
    end
  end

  describe 'PUT redirect_stream' do
    it 'assigns the read value to true' do
      put :redirect_stream, :notification => @enter_idea_notification.id
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @enter_idea_notification.id, user_id: @user.id })
      notification_user.read.should eq(true)
    end
  end

end