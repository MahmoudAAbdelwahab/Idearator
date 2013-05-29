require 'spec_helper'

describe CommentsController do
  include Devise::TestHelpers

  context 'comment creator wants to delete' do
    it 'deletes the comment' do
      @user = User.new
      @user.email = "Dayna@gmail.com"
      @user.confirm!
      @user.save
      @idea = Idea.new
      @idea.description=@idea.problem_solved=@idea.title= "Daynaaa's Idea"
      @idea.save
      @comment = Comment.new
      @comment.content ="Dayna's comment"
      @comment.user_id = @user.id
      @comment.idea_id = @idea.id
      @comment.save
      sign_in @user
      expect { delete :destroy, :id => @comment.id, :idea_id => @idea.id }.to change(Comment, :count).by(-1)
      response.should redirect_to @idea

    end
  end



  context 'normal user wants to delete comment' do
    it 'does not delete the comment' do
      @userone = User.new
      @userone.email = "One"
      @userone.confirm!
      @userone.save
      @usertwo = User.new
      @usertwo.email = "Two"
      @usertwo.confirm!
      @usertwo.save
      @idea = Idea.new
      @idea.description=@idea.problem_solved=@idea.title="Daynaaaaaa"
      @idea.save
      @comment = Comment.new
      @comment.content = "Dayna's comment"
      @comment.user_id = @userone.id
      @comment.idea_id = @idea.id
      @comment.save
      sign_in @usertwo
      expect { delete :destroy, :id => @comment.id, :idea_id => @idea.id }.to change(Comment, :count).by(0)
      response.should redirect_to @idea
    end
  end

  context "with valid attributes " do
    it "creates a new comment" do
      i = Idea.new
      i.title = "dayna"
      i.description = "description"
      i.problem_solved = "problem"
      i.save
      expect{
        post :create, :idea_id => i.id , :comment => { :content => "comment"}
      }.to change(Comment,:count).by(1)
    end


  end


  describe 'PUT update' do

    it "changes @comment's attributes" do
      @idea = Idea.new
      @idea.title=@idea.description=@idea.problem_solved="Daynaaaaaaa"
      @comment = Comment.new
      @comment.content="Daynaaaa Again"
      @comment.idea_id = @idea.id
      @idea.save
      @comment.save
      put :update,:id => @comment.id, :idea_id => @idea.id , :comment => { :content => "dayna "}
      @idea.reload
      @comment.reload
      @comment.content.should eq("dayna ")
    end
  end

  describe "GET #edit" do
    it "renders the #edit view" do
      idea = Idea.new
      idea.title= idea.description = idea.problem_solved = "dayna"
      idea.save
      comment = Comment.new
      comment.content = 'dayna'
      comment.save
      get :edit, :idea_id  => idea.id , :id => comment.id
      response.should render_template :edit
    end
  end
end
