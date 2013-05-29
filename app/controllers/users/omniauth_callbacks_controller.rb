class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include OmniauthHandlerMixin

  # Default action for oauth callbacks. Tries to find and sign in a +User+ object
  # and saves oauth data and yields to a block on failure
  # Params:
  # +request.env['omniauth.auth']+:: Omniauth authetication data recieved from
  #                                  authentications provider
  # +on_fail+:: Block to yield to on failure
  #
  # Author: Mina Nagy
  def default_oauth_callback(&on_fail)
    auth = request.env['omniauth.auth']

    @user = User.send("find_for_#{auth.provider.to_s}_oauth", auth, current_user)
    unless @user.persisted?
      # save oauth data if user creation failed
      session["devise.#{auth.provider.to_s}_data"] = auth.except(:extra)
    end
    auth.fail_redirect ||= new_user_registration_path

    unless handle_oauth_login
      if on_fail
        yield auth
      else
        default_oauth_fail
      end
    end
  end

  # Default oauth failure handling. Destroys the saved oauth session data and
  # displays the failure reason to the user.
  # Params:
  # +request.env['omniauth.auth']+:: Omniauth authetication data recieved from
  #                                  authentications provider
  #
  # Author: Mina Nagy
  def default_oauth_fail
    auth = request.env['omniauth.auth']
    session.delete("devise.#{auth.provider.to_s}_data")
    flash[:alert] = @user.errors.to_a[0] if @user.errors
    redirect_to auth.fail_redirect
  end
  # Finds User's authentication and redirects them to homepage.
  #
  # Params: None
  #
  # Author: Menna Amr
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      @user
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      request.env["omniauth.auth"]
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  # Twitter oauth callback. Gets redirected to from twitter.com after
  # authentication. Tries to login the +User+ or create a new +User+ object.
  # Params: None
  # Author: Mina Nagy
  def twitter
    default_oauth_callback do |auth|
      # username may already be taken, user will have to enter another one
      if User.exists? username: auth.info.nickname
        redirect_to controller: '/registrations', action: 'twitter_screen_name_clash'
      else
        default_oauth_fail
      end
    end
  end
end
