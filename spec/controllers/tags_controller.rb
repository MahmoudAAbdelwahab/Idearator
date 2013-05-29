require 'spec_helper'

describe TagsController do

  describe "GET ajax" do

# tests renders required json for auto complete
# Author: muhammed hassan
    it "auto completes tags" do
      t = Tag.new
      t.name = 'computer science'
      t.save

      t2 = Tag.new
      t2.name = 'life'
      t2.save

      get :ajax, :q => 'te' 
      response.body.should ==  "[{\"id\":1,\"name\":\"computer science\"}]"
    end

  end
end