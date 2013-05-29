require 'spec_helper'

describe CoolsterController do

  describe 'POST add_online_user' do

    it 'adds the user id passed to it to the list of online users in the Coolster module' do

      post :add_online_user, user: "1"
      expect(Coolster.online_user_ids).to include("1")

    end
  end

  describe 'POST remove_online_user' do

    it 'removes the user id passed to it from the list of online users in the Coolster module' do

      post :remove_online_user, user: "1"
      expect(Coolster.online_user_ids).to_not include("1")

    end
  end

end