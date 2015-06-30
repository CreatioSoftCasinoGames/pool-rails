class GameRequest < ActiveRecord::Base
	belongs_to :user
	belongs_to :game
	belongs_to :requested, foreign_key: :requested_to, class_name: "User"
	validate :search_requested_user, on: :create
	attr_accessor :requested_to_token

	def user_login_token
		user.login_token
	end

	def requested_token
		requested.login_token
	end

	def image_url
		requested.image_url
	end

	def full_name
		if requested.first_name.present?
			[requested.first_name, requested.last_name].join(", ")
		else
			"Guest User"
		end
	end
  
  private
  
	def search_requested_user
		requested_user = User.fetch_by_login_token(requested_to_token)
		if requested_user.present?
			self.requested_to = requested_user.id
		else
			self.errors.add(:base, "User not present!")
		end
	end

end
