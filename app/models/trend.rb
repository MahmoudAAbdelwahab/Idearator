class Trend < ActiveRecord::Base
  attr_accessible :vote, :idea_id , :trending , :created_at , :rounds
  has_many :ideas

  def self.del
    @trending = Trend.find(:all , :order => 'trending desc' , :limit =>4)
    @trending.each do |all|
      all.rounds = all.rounds + 1
      all.save
      all.trending = all.trending / (2**all.rounds)
      all.save
    end
  end
end
