class Threshold < ActiveRecord::Base
  attr_accessible :threshold

  # It resets the curr_day_votes for the current day and moves the old values in prev_day_votes,
  # to be used for comparison with the threshold.
  # Params:
  # none
  # Author: Hisham ElGezeery
  def self.threshold_run
    Threshold.create(:threshold => VoteCount.maximum('curr_day_votes'))
    @vote_counts = VoteCount.all
    VoteCount.all.each do |v|
      v.prev_day_votes = v.curr_day_votes
      v.curr_day_votes = 0
    end
  end
end
