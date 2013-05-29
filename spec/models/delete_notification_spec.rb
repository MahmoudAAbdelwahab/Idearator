require 'spec_helper'

describe DeleteNotification do
  before :each do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @idea = FactoryGirl.create(:idea)
    @idea.user = @user
    @notification = DeleteNotification.create(user: @user, idea: @idea, users: [@user], idea_title: @idea.title)
  end

  describe 'send_notification' do

    it 'adds delete idea notification to delete_notifications table'do
      DeleteNotification.send_notification(@user, @idea, [@user])
      expect(DeleteNotification.last.idea_id).to eq(@idea.id)
      expect(DeleteNotification.last.user_id).to eq(@user.id)
      expect(DeleteNotification.last.users).to include(@user)
    end

    it 'adds delete notification to notifications table' do
      expect(Notification.last.subtype).to eq ('DeleteNotification')
    end
    
  end

  describe 'text' do

    it 'returns the notifications text'do
      expect(@notification.text).to eq('user deleted his idea idea1.')
    end
  end

  describe 'read_by?' do

    it 'returns the value of the read variable'do
      notification_user= NotificationsUser.find(:first, :conditions => {notification_id: @notification.id, user_id: @user.id })
      expect(@notification.read_by?(@user)).to eq(notification_user.read)
    end

  end

  describe 'set_read_for' do

    it 'sets the value of read to true'do
      @notification.set_read_for(@user)
      notification_user= NotificationsUser.find(:first, :conditions => {notification_id: @notification.id, user_id: @user.id })
      expect(notification_user.read).to eq(true)
    end

  end

end
