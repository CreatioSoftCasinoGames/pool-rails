class ClientBug < ActiveRecord::Base
	after_create :send_mail

	private

	def send_mail
		UserMailer.send_error_mail(self).deliver
	end

end
