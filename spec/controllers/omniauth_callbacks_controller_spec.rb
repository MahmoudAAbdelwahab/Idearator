require 'spec_helper'

describe Users::OmniauthCallbacksController do
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

    describe "login via twitter" do
      it "should handle twitter callback" do
        get :twitter
        u = User.last
        subject.current_user.should eq(u)
      end
    end

    describe "login via twitter with an already used username" do
      it "should ask for a different username" do
        u1 = User.create(username: 'anno', email: 'anno@onymous.com', password: 'anomally')
        get :twitter
        response.should redirect_to(controller: '/registrations', action: 'twitter_screen_name_clash')
      end
    end

  end
end
