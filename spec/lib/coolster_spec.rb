require 'spec_helper'

describe Coolster do

  before :all do
    RestClient.stub!(:post)
  end

  describe 'add_to_online_users' do
    it 'adds the user id passed to it to the list of online users' do
      Coolster.add_to_online_users("1")
      expect(Coolster.online_user_ids).to include("1")
    end
  end

  describe 'remove_from_online_users' do
    it 'removes the user id passed to it from the list of online users' do
      Coolster.remove_from_online_users("1")
      expect(Coolster.online_user_ids).to_not include("1")
    end
  end

  describe 'update_all' do
    it 'sends http POST request with the input script as a parameter' do
      RestClient.should_receive(:post).with('http://localhost:9292/push_to_all', {script: "alert(1);", :multipart=>true})
      Coolster.update_all("alert(1);")
    end
  end

  describe 'update' do
    it'sends http POST request with the input script and the list of users to receive it as parameters' do
      RestClient.should_receive(:post).with("http://localhost:9292/push", {script: "alert(1);", users: ["1"], :multipart=>true})
      Coolster.add_to_online_users("1")
      Coolster.update(["1", "2"], "alert(1);")
    end
  end

  describe 'update_each' do
    it 'sends http POST request with a hash of scripts generated from the input block' do
      RestClient.should_receive(:post).with("http://localhost:9292/push_to_each", {scripts: {"1" => "alert(1);"}, :multipart=>true})
      Coolster.add_to_online_users("1")
      Coolster.update_each(["1", "2"]) do |user|
        "alert(" + user + ");"
      end
    end
  end

end