require 'spec_helper'

describe Invited do
  context '' do
    it'should add the best idea of the month to Monthly Winner' do
      i=Idea.new
      i.title='bla'
      i.description='bla'
      i.problem_solved='bla'
      i.num_votes=3
      i.save
      x=Idea.new
      x.title='ay7aga'
      x.description='ay7aga'
      x.problem_solved='ay7aga'
      x.num_votes=5
      x.save
      Idea.best_idea_for_month(Time.now - 1.day)
      MonthlyWinner.last.idea_id.should eql(2)
    end
  end

end