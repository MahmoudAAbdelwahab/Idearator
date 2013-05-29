class CommitteesTags < ActiveRecord::Base
   attr_accessible :committee_id, :tag_id
   validates_presence_of :tag_id
end
