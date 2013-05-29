require 'spec_helper'

describe RegistrationsController do
  context "user wants to login using a social network" do
    before do 
      OmniAuth.config.test_mode = true

      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        :provider => 'twitter',
        :uid => '123545',
        :info => OmniAuth::AuthHash.new({
          name: "Ann O. Neemus",
          nickname: "anno",
        })
      })

      request.env["devise.mapping"] = Devise.mappings[:user] 
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
    end

    describe "twitter screen name clash handling" do
      it "should allow the user to choose a new username" do
        session['devise.twitter_data'] = OmniAuth.config.mock_auth[:twitter]
        u1 = User.create(username: 'anno', email: 'anno@onymous.com', password: 'anomally')
        get :twitter_screen_name_clash
        response.should render_template('devise/registrations/twitter_screen_name_clash')
        get :twitter_screen_name_clash, username: 'anno'
        response.should render_template('devise/registrations/twitter_screen_name_clash')
        get :twitter_screen_name_clash, username: 'anno2'
        response.should render_template('devise/mailer/confirmation_instructions')
        User.last.username.should eq('anno2')
        User.last.should eq(subject.current_user)
      end
    end

  end
end
