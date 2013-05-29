require 'spec_helper'

describe IdeasController do
  include Devise::TestHelpers

  RSpec.configure do |config|
    config.mock_framework = :rspec
  end

  describe 'PUT archive' do
    context 'idea creator wants to archive' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.user_id = @user.id
        @idea.save
        @vote = FactoryGirl.build(:vote)
        @vote.user_id = @user.id
        @vote.idea_id = @idea.id
        @vote.save
        @rating = FactoryGirl.build(:rating)
        @rating.idea_id = @idea.id
        @rating.save
        @user_rating = FactoryGirl.build(:user_rating)
        @user_rating.user_id = @user.id
        @user_rating.rating_id = @rating.id
        @user_rating.save
        sign_in @user
      end

      it 'archives the idea' do
        put :archive, :id => @idea.id
        @idea.reload
        (@idea.archive_status).should eql(true)
      end

      it 'deletes idea votes' do
        expect { put :archive, :id => @idea.id }.to change(Vote, :count).by(-1)
      end

      it 'deletes user ratings' do
        expect { put :archive, :id => @idea.id }.to change(UserRating, :count).by(-1)
      end
    end

    context 'admin wants to archive' do
      before :each do
        @admin = FactoryGirl.build(:admin)
        @admin.confirm!
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.user_id = @user.id
        @idea.save
        @vote = FactoryGirl.build(:vote)
        @vote.user_id = @user.id
        @vote.idea_id = @idea.id
        @vote.save
        @rating = FactoryGirl.build(:rating)
        @rating.idea_id = @idea.id
        @rating.save
        @user_rating = FactoryGirl.build(:user_rating)
        @user_rating.user_id = @user.id
        @user_rating.rating_id = @rating.id
        @user_rating.save
        sign_in @admin
      end

      it 'archives the idea' do
        put :archive, :id => @idea.id
        @idea.reload
        (@idea.archive_status).should eql(true)
      end

      it 'deletes idea votes' do
        expect { put :archive, :id => @idea.id }.to change(Vote, :count).by(-1)
      end

      it 'deletes user ratings' do
        expect { put :archive, :id => @idea.id }.to change(UserRating, :count).by(-1)
      end
    end

    context 'normal user wants to archive' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        sign_in @user
      end

      it 'does not archive the idea' do
        @arch_stat = @idea.archive_status
        put :archive, :id => @idea.id
        @idea.reload
        (@idea.archive_status).should eql(@arch_stat)
      end

      it 'does not delete idea votes' do
        expect { put :archive, :id => @idea.id }.to change(Vote, :count).by(0)
      end

      it 'does not delete user ratings' do
        expect { put :archive, :id => @idea.id }.to change(UserRating, :count).by(0)
      end
    end
  end

  describe 'PUT unarchive' do
    context 'idea creator wants to unarchive' do
      before :each do
        @user = FactoryGirl.create(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.user_id = @user.id
        @idea.archive_status = true
        @idea.save
        sign_in @user
      end

      it 'unarchives the idea' do
        put :unarchive, :id => @idea.id, :format => 'js'
        @idea.reload
        (@idea.attributes['archive_status']).should eql(false)
      end
    end

    context 'admin wants to unarchive' do
      before :each do
        @admin = FactoryGirl.build(:admin)
        @admin.confirm!
        @idea = FactoryGirl.create(:idea)
        sign_in @admin
      end

      it 'unarchives the idea' do
        put :unarchive, :id => @idea.id, :format => 'js'
        @idea.reload
        (@idea.archive_status).should eql(false)
      end
    end

    context 'normal user wants to unarchive' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        sign_in @user
      end

      it 'does not unarchive the idea' do
        @arch_stat = @idea.archive_status
        put :unarchive, :id => @idea.id, :format => 'js'
        @idea.reload
        (@idea.archive_status).should eql(@arch_stat)
      end
    end
  end

  it 'show ' do
    @user = User.new
    @user.email = "119ggpkkkkkq@gmail.com"
    @user.confirm!
    @user.save
    idea = Idea.new
    idea.title = idea.description = idea.problem_solved = "Dayna"
    idea.save
    @comment = Comment.new
    @comment.content = "dayna"
    @comment.idea_id = idea.id
    @comment.num_likes = 0
    @comment.save
    @like = Like.new
    @like.user_id = @user.id
    @like.comment_id = @comment.id
    @like.save
    sign_in @user
    get :like , :id => idea.id , :commentid => @comment.id
    @comment.reload
    @comment.num_likes.should eq(1)
  end

  describe 'DELETE destroy' do
    context 'idea creator wants to delete' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.user_id = @user.id
        @idea.save
        @vote = FactoryGirl.build(:vote)
        @vote.user_id = @user.id
        @vote.idea_id = @idea.id
        @vote.save
        @rating = FactoryGirl.create(:rating)
        @rating.idea_id = @idea.id
        @rating.save
        @user_rating = FactoryGirl.build(:user_rating)
        @user_rating.rating_id = @rating.id
        @user_rating.user_id = @user.id
        @user_rating.save
        sign_in @user
      end

      it 'deletes the idea' do
        expect { delete :destroy, :id => @idea.id }.to change(Idea, :count).by(-1)
      end

      it 'redirects to home' do
        delete :destroy, :id => @idea.id
        response.should redirect_to '/'
      end

      it 'deletes idea votes' do
        expect { delete :destroy, :id => @idea.id }.to change(Vote, :count).by(-1)
      end

      it 'deletes idea ratings' do
        expect { delete :destroy, :id => @idea.id }.to change(Rating, :count).by(-1)
      end

      it 'deletes idea user ratings' do
        expect { delete :destroy, :id => @idea.id }.to change(UserRating, :count).by(-1)
      end
    end

    context 'normal user wants to delete idea' do
      before :each do
        @userone = FactoryGirl.build(:user)
        @userone.confirm!
        @usertwo = FactoryGirl.build(:user_two)
        @usertwo.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.user_id = @userone.id
        @idea.save
        @vote = FactoryGirl.build(:vote)
        @vote.user_id = @userone.id
        @vote.idea_id = @idea.id
        @vote.save
        @rating = FactoryGirl.build(:rating)
        @rating.idea_id = @idea.id
        @rating.save
        @user_rating = FactoryGirl.build(:user_rating)
        @user_rating.rating_id = @rating.id
        @user_rating.user_id = @userone.id
        @user_rating.save
        sign_in @usertwo
      end

      it 'does not delete the idea' do
        expect { delete :destroy, :id => @idea.id }.to change(Idea, :count).by(0)
      end

      it 'redirects to idea' do
        delete :destroy, :id => @idea.id
        response.should redirect_to @idea
      end

      it 'does not delete idea votes' do
        expect { delete :destroy, :id => @idea.id }.to change(Vote, :count).by(0)
      end

      it 'does not delete idea ratings' do
        expect { delete :destroy, :id => @idea.id }.to change(Rating, :count).by(0)
      end

      it 'does not delete idea user ratings' do
        expect { delete :destroy, :id => @idea.id }.to change(UserRating, :count).by(0)
      end
    end
  end

  it 'likes a comment ' do
    @user = User.new
    @user.email = "119ggpkkkkkq@gmail.com"
    @user.confirm!
    @user.save
    idea = Idea.new
    idea.title = idea.description = idea.problem_solved = "Dayna"
    idea.save
    @comment = Comment.new
    @comment.content = "dayna"
    @comment.idea_id = idea.id
    @comment.num_likes = 0
    @comment.save
    @like = Like.new
    @like.user_id = @user.id
    @like.comment_id = @comment.id
    @like.save
    sign_in @user
    get :like , :id => idea.id , :commentid => @comment.id
    @comment.reload
    @comment.num_likes.should eq(1)

  end


  describe 'GET #show' do
    before :each do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      @idea = FactoryGirl.create(:idea)
      @idea.user_id = @user.id
      @idea.save
      sign_in @user
    end

    it 'assigns the requested idea to @idea' do
      get :show, :id => @idea.id
      assigns(:idea).should eq(@idea)
    end

    it 'renders the #show view' do
      get :show, id: FactoryGirl.attributes_for(:idea)
      response.should render_template :show
    end
  end

  describe 'GET #new' do
    before :each do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      sign_in @user
    end

    it 'assigns a new Idea to @idea' do
      @idea = FactoryGirl.create(:idea)
      get :new
      assigns(:idea).should equal(@idea)
    end

    it 'renders the #new view' do
      get :new, :format => 'html'
      response.should render_template 'new'
    end
  end

  describe 'POST #create' do

    context 'normal idea creation' do
      it 'creates a new idea' do
        @idea = Idea.new
        @idea.title = @idea.description = @idea.problem_solved = 'ay7aga'
        @idea.save
        post :create, :idea => FactoryGirl.attributes_for(:idea), :idea_tags => { :tags => [] }
        @idea.reload
        Idea.last.should eq(@idea)
      end
    end

    context 'Idea Creation for competition' do
      before :each do
        @u1 = User.new(:email => 'u@gmail.com', :password => '123123123', :username => 'u')
        @u1.confirm!
        @u1.save
        @i1 = Investor.new(:email => 'i@gmail.com', :password => '123123123', :username => 'i')
        @i1.confirm!
        @i1.save
        @competition = Competition.create(:title => 'title', :description => 'description')
        @competition.investor = @i1
        @competition.save
        sign_in @u1
      end
      it 'creates the idea' do
        expect { post :create, :idea => FactoryGirl.attributes_for(:idea), :idea_tags => { :tags => [] }, :competition_id => @competition.id }.to change(Idea, :count).by(1)
      end
      it 'appends the idea to competition list' do
        expect { post :create, :idea => FactoryGirl.attributes_for(:idea), :idea_tags => { :tags => [] }, :competition_id => @competition.id }.to change(CompetitionEntry, :count).by(1)
      end
    end
  end


  describe 'POST #edit' do

    it 'edits an idea' do
      @idea1 = Idea.new
      @idea1.title = @idea1.description = @idea1.problem_solved = 'ay7aga'
      @tag1 = @idea1.tags.new
      @tag1.name = 'blah'
      @tag1.save
      @idea1.save
      put :update, :id => @idea1.id, :idea => { :title => 'ay title' }
      @idea1.reload
      @idea1.title.should eq('ay title')
    end
  end

  describe 'PUT vote' do
    context 'user wants to vote' do
      before :each do
        @user = FactoryGirl.build(:user)
        @user.confirm!
        @idea = FactoryGirl.create(:idea)
        @idea.user_id = @user.id
        @idea.save
        sign_in @user
      end

      it 'idea id in user.votes' do
        put :vote, :id => @idea.id
        @idea.reload
        @voted = @user.votes.find(@idea)
        (@voted.id).should eql(@idea.id)
      end

      it 'redirects to idea' do
        put :vote, :id => @idea.id
        response.should redirect_to @idea
      end

      it 'increase idea votes' do
        @numvotes = @idea.num_votes + 1
        put :vote, :id => @idea.id
        @idea.reload
        (@numvotes).should eql(@idea.num_votes)
      end
    end
  end

  context 'user wants to unvote' do
    before :each do
      @user = FactoryGirl.build(:user)
      @user.confirm!
      @idea = FactoryGirl.create(:idea)
      @idea.user_id = @user.id
      @idea.save
      sign_in @user
    end

    it 'idea id deleted from user.votes' do
      put :unvote, :id => @idea.id
      @idea.reload
      @voted = @user.votes.find(:first, :conditions => {id: @idea_id})
      (@voted).should eql(nil)
    end

    it 'redirects to idea' do
      put :unvote, :id => @idea.id
      response.should redirect_to @idea
    end

    it 'increase idea votes' do
      @numvotes = @idea.num_votes - 1
      put :unvote, :id => @idea.id
      @idea.reload
      (@numvotes).should eql(@idea.num_votes)
    end
  end

  describe 'PUT enter_competition' do
    before :each do
      @u1 = User.new(:email => 'u@gmail.com', :password => '123123123', :username => 'u')
      @u1.confirm!
      @u1.save
      @i1 = Investor.new(:email => 'i@gmail.com', :password => '123123123', :username => 'i')
      @i1.confirm!
      @i1.save
      @idea = Idea.create(:title => 'title', :description => 'description', :problem_solved => 'problem_solved', :approved => true)
      @competition = Competition.create(:title => 'title', :description => 'description')
      @competition.investor = @i1
      @competition.save
      @u1.ideas << @idea
      sign_in @u1
    end
    context 'Success Scenario' do
      it 'retrieves valid competition and idea id from :id and :id1' do
        put :enter_competition, :id => @idea.id, :competition_id => @competition.id
        assigns(:idea).should_not eq(nil)
        assigns(:competition).should_not eq(nil)
      end
      it 'adds the idea to the competition ideas list' do
        expect { put :enter_competition, :id => @idea.id, :competition_id => @competition.id } .to change(CompetitionEntry, :count).by(1)
      end
      it 'calls send_notification in EnterIdeaCompetition' do
        expect { put :enter_competition, :id => @idea.id, :competition_id => @competition.id } .to change(EnterIdeaNotification, :count).by(1)
      end
      it 'redirects to competition show page' do
        put :enter_competition, :id => @idea.id, :competition_id => @competition.id
        response.should redirect_to "/ideas/#{@idea.id}"
      end
    end
    context 'Failure Scenario' do
      it 'does not append competitions list if idea is already in competition' do
        @competition.ideas << @idea
        expect { put :enter_competition, :id => @idea.id, :competition_id => @competition.id }.to change(CompetitionEntry, :count).by(0)
      end
    end
  end
end
