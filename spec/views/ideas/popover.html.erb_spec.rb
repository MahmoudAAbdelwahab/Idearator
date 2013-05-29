require "spec_helper"

describe "ideas/popover" do
# tests popover is rendered
# Author: Dayna
before :each do
  @tag = Tag.new
  @tag.name = "Dayna"
  @tag.save
  @user = FactoryGirl.build(:user)
  @user.confirm!
  @user.save
  @idea = FactoryGirl.create(:idea)
  @idea.user_id = @user.id
  @idea.description = "Lorem "
  @idea.save
  it = IdeasTags.new
  it.idea_id = @idea.id
  it.tag_id = @tag.id
  it.save
  @vote = FactoryGirl.build(:vote)
  @vote.user_id = @user.id
  @vote.idea_id = @idea.id
  @vote.save
end
it "has a button vote" do
  render :template => "/ideas/_popover", :locals => {:idea => @idea , :vote =>@vote ,:user_id => @user}
  rendered.should include("class=\"btn btn-success margin\"")
  rendered.should have_tag("img")
  rendered.should have_tag("h5")
  rendered.should include("id='desPop'")
  rendered.should include("class=\"text-info\"")
  rendered.should include("id= 'titleTag'")
  rendered.should include("class=\"label label-info \"")
  rendered.should include("id='commentsPopover'")
end
end