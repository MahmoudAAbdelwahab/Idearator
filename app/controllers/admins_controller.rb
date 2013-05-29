class AdminsController < ApplicationController
  before_filter do
    unless current_user and current_user.is_a? Admin
      redirect_to '/stream/index'
    end
  end

# checks invitation is valid and delivers the email
# +email+:: the email of the  guest
# Author: muhammed hassan
  def invite_committee
    if User.find(:all, :conditions => {:email => params[:email]}).length ==0
      i = Invited.creates( params[:email] , current_user.id )
      # after integrating with login 5 shoulld be replaced with current_user.id
      if i.valid?
        mail = Inviter.invite_email(params[:email])
        mail.deliver
        flash[:notice] = 'success'
      else
        flash[:error] = i.errors.full_messages.to_s
      end
    else
      flash[:error] = 'user already exists'
    end
    redirect_to :controller => 'stream', :action => 'index'
  end

# toggles the ban status of the selected user
# Author: Omar Kassem
  def ban_unban
    if current_user
      if current_user.type == 'Admin'
        @user=User.find(params[:id])
        @user.toggle(:banned)
        @user.save
        redirect_to :controller => 'users', :action => 'show'
      end
    else
    respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You cant ban/unban users' }
        format.json { head :no_content }

      end
    end
  end

end
