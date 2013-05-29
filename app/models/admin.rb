class Admin < User
  # attr_accessible :title, :body

  has_many :inviteds
end
