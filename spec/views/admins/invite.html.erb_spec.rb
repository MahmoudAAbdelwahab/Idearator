require "spec_helper"

describe "admins/invite.html.erb" do

  # tests invitation form is rendered
  # Author: muhammed hassan
  it "displays invitation form" do
    render
    rendered.should include("<div id=\"example\"")
    rendered.should include("<a data-toggle=\"modal\" href=\"#example\"")
  end

end