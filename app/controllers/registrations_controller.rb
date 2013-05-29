class RegistrationsController < Devise::RegistrationsController
  include OmniauthHandlerMixin

  # This method overrides the original devise method in order to show the list of tags the user can choose
  # from if they signed up as a committee member
  #
  # params: None
  #
  # Author: Menna Amr
  def new
    @tags = Tag.all
    super
  end

  # This method overrides the original devise method to ensure the use
  # actually chose their area(s) of expertise and throw an error message if
  # none were chosen
  #
  # params: None
  #
  # Author: Menna Amr
  def create
    build_resource

    @tags = Tag.all

    if resource.type == "Committee" && params[:tags].nil?
      set_flash_message :error, :select_expertise
      redirect_to "/users/sign_up" and return
    end

    if resource.save
      if resource.type == "Committee"
        UserMailer.committee_signup("menna.amr2@gmail.com").deliver
        resource.becomes(Committee).tag_ids = params[:tags]
      end

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  # Allow the user to choose a different username if user's twitter screen name
  # is already used as a username locally
  #
  # Params:
  # +session['devise.twitter_data']+:: Saved twitter oauth data from login request
  # +params[:username]+:: New username that has been chosen by user
  #
  # Author: Mina Nagy
  def twitter_screen_name_clash
    auth = session['devise.twitter_data']
    raise ActiveResource::UnauthorizedAccess.new('Unauthorized') unless auth

    if params[:username]
      auth.chosen_user_name = params[:username]
      render and return if User.exists? username: params[:username]
      @user = User.create_user_from_twitter_oauth(auth)
      unless handle_oauth_login
        flash[:alert] = @user.errors.to_a[0] if @user.errors
        redirect_to new_user_registration_path
      end
    end
  end

  # Deny the user from Signing In if User is banned
  #
  # Params: +resrouce+:: The user object
  #
  # Author: Menna Amr
  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.banned?
      sign_out resource
      flash[:error] = "This account has been suspended."
      root_path
    else
      super
    end
   end
end
