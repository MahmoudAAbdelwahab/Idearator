require 'spec_helper'

describe DeleteCompetitionNotification do
  before :each do
    @user = FactoryGirl.create(:investor)
    @user.confirm!
    @competition = FactoryGirl.create(:notification_competition)
    @competition.investor = @user
    @competition.save
    @notification = DeleteCompetitionNotification.create(user: @user, competition: @competition, users: [@user], competition_title: @competition.title)
  end

  describe 'send_notification' do

    it 'adds delete competition notification to delete_competition_notifications table'do
      DeleteCompetitionNotification.send_notification(@user, @competition, [@user])
      expect(DeleteCompetitionNotification.last.competition_id).to eq(@competition.id)
      expect(DeleteCompetitionNotification.last.user_id).to eq(@user.id)
      expect(DeleteCompetitionNotification.last.users).to include(@user)
    end

    it 'adds delete competition notification to notifications table' do
      expect(Notification.last.subtype).to eq ('DeleteCompetitionNotification')
    end
    
  end

  describe 'text' do

    it 'returns the notifications text'do
      expect(@notification.text).to eq('investor deleted his competition title.')
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
