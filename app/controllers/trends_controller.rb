class TrendsController < ApplicationController
  class VoteHooks
    #Select the recent five votes and calculates the time between them
    #in order to set trending
    #Params:
    #+vote+ :: the parameter is an instance of +Vote+
    #Author: Hesham Nabil
    def after_save(vote)
      v = Vote.find(:all , :conditions => { :idea_id  => vote.idea_id }, :order => 'created_at desc', :limit=> 5 )
      diff = Time.now - v.last.created_at
      if diff.to_i < 200
        t = Idea.find(vote.idea_id).trend
        t.trending = t.trending + 4
        t.save
      end
      if diff.to_i <400 && diff.to_i >200
        t = Idea.find(vote.idea_id).trend
        t.trending = t.trending + 2
        t.save
      end
      if diff.to_i < 1200 && diff.to_i > 400
        t = Idea.find(vote.idea_id).trend
        t.trending = t.trending + 1
        t.save
      end
    end
  end

  class IdeaHooks
    def after_save(idea)
      t = Trend.new
      t.idea_id = idea.id
      t.save
    end
  end
end
