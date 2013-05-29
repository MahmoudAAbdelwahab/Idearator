class UserMailer < ActionMailer::Base
  default from: "menna.amr2@gmail.com"

  #This method sends an email to the Admin
  #if a user signed up as committee to inform them
  #that they should accept/reject their application
  #Params: admin
  #Author: Menna Amr
  def committee_signup(admin)
    mail(:to => admin, :subject => "New Committee Member Sign Up")
  end

  # Sends mail confirming registration
  # Params:
  # +email+:: the parameter is an instance of +User.email+ passed through the button_to Approve Committee
  # Author: Mohammad Abdulkhaliq
  def committee_accept(user)
    @user = user
    @url  = app.root_url
    mail(:to => user.email, :subject => "Congratulations!")
  end

  # Sends mail rejecting registration
  # Params:
  # +email+:: the parameter is an instance of +User.email+ passed through the button_to Approve Committee
  # Author: Mohammad Abdulkhaliq
  def committee_reject(user)
    @user = user
    @url  = app.root_url
    mail(:to => user.email, :subject => "Idearator")
  end

end
