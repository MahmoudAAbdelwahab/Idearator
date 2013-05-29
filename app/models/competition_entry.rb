class CompetitionEntry < ActiveRecord::Base
  attr_accessible :idea_id, :competition_id, :approved

  belongs_to :idea
  belongs_to :competition
end
