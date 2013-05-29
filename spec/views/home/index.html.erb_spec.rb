require "spec_helper"

# tests the index view
# Author: muhammed hassan
describe "home/index.html.erb" do

  it "displays current tags" do
    assign(:tags2, [
      'slicer','dicer'
    ])
    u =User.new
    u.email = 'abuali@yahoo.com'
    u.first_name = 'f'
    u.username = 'k'
    u.password = 123123123
    u.confirm!
    u.save
    assign(:approved, [
      stub_model(Idea, :title => "slicer" ,
      :user_id => u.id,
      :title => Faker::Name.name,
      :description => Faker::Lorem.paragraph,
      :problem_solved => Faker::Lorem.paragraph,
      :approved => "true",
      :num_votes => rand(1..500) )
      ])
    render
    rendered.should include("slicer")
    rendered.should include("dicer")
  end

end

