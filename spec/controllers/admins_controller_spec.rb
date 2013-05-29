require 'spec_helper'

describe AdminsController do
  describe 'PUT ban_unban' do
    include Devise::TestHelpers
    context 'admin wants to ban/unban user' do
      it 'change the status of the user ' do
        @admin=Admin.new
        @admin.email='o@gmail.com'
        @admin.password=123123123
        @admin.username='a'
        @admin.confirm!
        @admin.save
        @user=User.new
        @user.email='a@gmail.com'
        @user.password=123123123
        @user.username='b'
        @user.confirm!
        @user.save
        sign_in @admin
        put :ban_unban, :id => @user.id
        @user.reload
        (@user.banned).should eql(true)
      end

      it 'can not change the status of the user ' do
        @admin=User.new
        @admin.email='o@gmail.com'
        @admin.password=123123123
        @admin.username='a'
        @admin.confirm!
        @admin.save
        @user=User.new
        @user.email='a@gmail.com'
        @user.password=123123123
        @user.username='b'
        @user.confirm!
        @user.save
        sign_in @admin
        put :ban_unban, :id => @user.id
        @user.reload
        (@user.banned).should eql(false)
      end
    end
  end
end
