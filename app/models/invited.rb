class Invited < ActiveRecord::Base

  # attr_accessible :title, :body
  attr_accessible :email, :admin_id
  validates :email ,
    :presence => true,
    :uniqueness => true,
    :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
  validates :admin_id,  :presence => true
  belongs_to :admin

  # checks the validations and creates new +Invited+ object
  # Params:
  # +email+:: the email of the  guest
  # +admin_id+:: the id of the admin making the invitation
  # Author: muhammed hassan
  def self.creates(mail ,id)
    i = Invited.new(:email=> mail , :admin_id => id)
    if i.valid?
      i.save
    end
    return i
  end

end
