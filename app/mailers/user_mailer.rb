class UserMailer < ActionMailer::Base
  default from: "bugs@creatiosoft.com"

  def send_error_mail(error)
  	# mail(to: "kumar.neeraj@creatiosoft.com", subject: error.bug_type )
  	# mail(to: "amrendra@creatiosoft.com", subject: error.bug_type " || " error.exception)
  	# mail(to: "narendra@creatiosoft.com", subject: error.bug_type " || " error.exception)
  	# mail(to: "manishkumar@creatiosoft.com", subject: error.bug_type " || " error.exception)" || " error.exception
  end
end
