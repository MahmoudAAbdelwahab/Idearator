# Mixin for common oauth methods used by various controllers
module OmniauthHandlerMixin
  # If a user was found or created successfully after oauth authentication, log
  # them in and close the popup
  # Params:
  # +params[:state]+:: If defined and set to 'popup' then render a javscript
  #                    snippet that closes the login popup instead of redirecting
  #
  # Author: Mina Nagy
  def handle_oauth_login
    if @user.persisted?
      @user.confirm!
      set_flash_message(:notice, :success, :kind => @user.provider.to_s.capitalize) if is_navigational_format?
      if params[:state] == 'popup'
        sign_in @user, :event => :authentication
        render 'devise/registrations/close_login_popup', :layout => false
      else
        sign_in_and_redirect @user, :event => :authentication
      end
      return true
    else
      return false
    end
  end
end

