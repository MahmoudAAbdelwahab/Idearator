require 'spec_helper'

describe CompetitionsController do
  include Devise::TestHelpers

  describe 'Review Competition Idea' do
    context 'User wants to review ideas' do
      before :each do
        @i=Investor.new
        @i.email='i.gmail.com'
        @i.password=123123123
        @i.username='i'
        @i.confirm!
        @i.save
        @u=Investor.new
        @u.email='u@gmail.com'
        @u.password=123123123
        @u.username='u'
        @u.confirm!
        @u.save
        @c=Competition.new
        @c.title='bla'
        @c.description='bla'
        @c.investor_id=@i.id
        @c.save
        @idea=Idea.new
        @idea.title='blabla'
        @idea.description='blabla'
        @idea.problem_solved='blabla'
        @idea.save
        @idea1=Idea.new
        @idea1.title='bla'
        @idea1.description='bla'
        @idea1.problem_solved='bla'
        @idea1.save
        @idea2=Idea.new
        @idea2.title='ay7aga'
        @idea2.description='ay7aga'
        @idea2.problem_solved='ay7aga'
        @idea2.save
        @idea3=Idea.new
        @idea3.title='blablabla'
        @idea3.description='blablabla'
        @idea3.problem_solved='blablabla'
        @idea3.save
        @ce=CompetitionEntry.new
        @ce.idea_id=@idea.id
        @ce.competition_id=@c.id
        @ce.save
        @ce1=CompetitionEntry.new
        @ce1.idea_id=@idea1.id
        @ce1.competition_id=@c.id
        @ce1.approved=true
        @ce1.save
        @ce2=CompetitionEntry.new
        @ce2.idea_id=@idea2.id
        @ce2.competition_id=@c.id
        @ce2.rejected=true
        @ce2.save
        @ce2=CompetitionEntry.new
        @ce2.idea_id=@idea2.id
        @ce2.competition_id=@c.id
        @ce2.rejected=true
        @ce2.save

      end

      it 'should show the investor only the ideas on his competition that are not approved or rejected yet' do
        sign_in @i
        get :review_competitions_ideas, :id => @c.id
        assigns(:ideas).count.should eql(1)
      end

      it 'should redirect guest to home page' do
        get :review_competitions_ideas, :id => @c.id
        response.should redirect_to '/'
      end

      it 'should redirect Investor who doesnt own the Competition to home page' do
        sign_in @u
        get :review_competitions_ideas, :id => @c.id
        response.should redirect_to '/'
      end
    end
  end

  describe 'approve' do
    context 'approving a certain idea to enter the competition' do
      before :each do
        @i=Investor.new
        @i.email='i.gmail.com'
        @i.password=123123123
        @i.username='i'
        @i.confirm!
        @i.save
        @c=Competition.new
        @c.title='bla'
        @c.description='bla'
        @c.investor_id=@i.id
        @c.save
        @idea=Idea.new
        @idea.title='blabla'
        @idea.description='blabla'
        @idea.problem_solved='blabla'
        @idea.save
        @ce=CompetitionEntry.new
        @ce.idea_id=@idea.id
        @ce.competition_id=@c.id
        @ce.save
        @u=Investor.new
        @u.email='u@gmail.com'
        @u.password=123123123
        @u.username='u'
      end

      it 'should change the approve status of the Competition entry' do
        sign_in @i
        get :approve, :id =>@c.id ,:idea_id => @idea.id
        @ce.reload
        @ce.approved.should eql(true)
      end

      it 'should redirect guest to home page' do
        get :approve, :id =>@c.id ,:idea_id => @idea.id
        response.should redirect_to '/'
      end

      it 'should redirect Investor who doesnt own the Competition to home page' do
        sign_in @u
        get :approve, :id =>@c.id ,:idea_id => @idea.id
        response.should redirect_to '/'
      end
    end
  end

  describe 'reject' do
    context 'rejecting the participation of a certain idea in the competition' do
      before :each do
        @i=Investor.new
        @i.email='i.gmail.com'
        @i.password=123123123
        @i.username='i'
        @i.confirm!
        @i.save
        @c=Competition.new
        @c.title='bla'
        @c.description='bla'
        @c.investor_id=@i.id
        @c.save
        @idea=Idea.new
        @idea.title='blabla'
        @idea.description='blabla'
        @idea.problem_solved='blabla'
        @idea.save
        @ce=CompetitionEntry.new
        @ce.idea_id=@idea.id
        @ce.competition_id=@c.id
        @ce.save
        @u=Investor.new
        @u.email='u@gmail.com'
        @u.password=123123123
        @u.username='u'
      end

      it 'should change the reject status of the competition entry' do
        sign_in @i
        get :reject, :id =>@c.id ,:idea_id => @idea.id
        @ce.reload
        @ce.rejected.should eql(true)
      end

      it 'should redirect guest to home page' do
        get :reject, :id =>@c.id ,:idea_id => @idea.id
        response.should redirect_to '/'
      end

      it 'should redirect Investor who doesnt own the Competition to home page ' do
        sign_in @u
        get :reject, :id =>@c.id ,:idea_id => @idea.id
        response.should redirect_to '/'
      end
    end
  end

  describe "GET #index" do
    before :each do
      @investor = FactoryGirl.create(:investor)
      @investor.confirm!
      @investor2 = FactoryGirl.create(:investor,email: 'abuali@yahoo.com',username: 'hamed')
      @investor2.confirm!
      @tag1 = Tag.new(:name => 'Science')
      @tag2 = Tag.new(:name => 'Games')
      5.times do
        @competition1 = FactoryGirl.create(:competition,tags: [@tag1,@tag2],investor: @investor)
      end
      6.times do
        @competition2 = FactoryGirl.create(:competition,tags: [@tag1] ,investor: @investor2)
      end
    end

    it "returns all competitions" do
      get :index
      assigns(:competitions).should have(10).items
    end

    it "filters competitions" do
      get :index, :tags => ['a','Games']
      assigns(:competitions).should have(5).items
    end

    it "returns all competitions when tags are empty" do
      get :index, :tags => ['a']
      assigns(:competitions).should have(10).items
    end

    it "allow infinite scrolling" do
      get :index, :myPage => 2,:tags => ['a']
      assigns(:competitions).should have(1).items
    end

    it "scrolls with filtering" do
      get :index, :tags => ['a','Games'], :myPage => 2
      assigns(:competitions).should have(0).items
    end

    it "filters competitions for investor" do
      sign_in(@investor)
      get :index, :type => 1
      assigns(:competitions).should have(5).items
    end

  end

  describe "tests" do
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

    describe 'PUT enroll_idea' do
      context 'Success Scenario' do
        it 'retrieves valid competition and idea id from :id and :id1' do
          put :enroll_idea, :id => @competition.id, :idea_id => @idea.id
          assigns(:idea).should_not eq(nil)
          assigns(:competition).should_not eq(nil)
        end
        it 'adds the idea to the competition ideas list' do
          expect { put :enroll_idea, :id => @competition.id, :idea_id => @idea.id } .to change(CompetitionEntry, :count).by(1)
        end
        it 'calls send_notification in EnterIdeaCompetition' do
          expect { put :enroll_idea, :id => @competition.id, :idea_id => @idea.id } .to change(EnterIdeaNotification, :count).by(1)
        end
        it 'redirects to competition show page' do
          put :enroll_idea, :id => @competition.id, :idea_id => @idea.id
          response.should redirect_to "/competitions/#{@competition.id}"
        end
      end
      context 'Failure Scenario' do
        it 'does not append competitions list if idea is already in competition' do
          @competition.ideas << @idea
          expect { put :enroll_idea, :id => @competition.id, :idea_id => @idea.id }.to change(CompetitionEntry, :count).by(0)
        end
      end
    end
  end

end
