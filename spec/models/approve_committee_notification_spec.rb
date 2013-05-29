require 'spec_helper'

describe ApproveCommitteeNotification do
  before :each do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @notification = ApproveCommitteeNotification.create(user: @user, users: [@user])
  end

  describe 'send_notification' do

    it 'adds approve committee notification to user_notifications table'do
      ApproveCommitteeNotification.send_notification(@user, [@user])
      expect(UserNotification.last.type).to eq('ApproveCommitteeNotification')
      expect(UserNotification.last.user_id).to eq(@user.id)
      expect(UserNotification.last.users).to include(@user)
    end

    it 'adds approve committee notification to notifications table' do
      expect(Notification.last.subtype).to eq ('ApproveCommitteeNotification')
    end

  end

  describe 'text' do

    it 'returns the notifications text'do
      expect(@notification.text).to eq('user has signed up as a committee member.')
    end

  end

  describe 'read_by?' do

    it 'returns the value of the read variable'do
      notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @notification.id, user_id: @user.id })
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
