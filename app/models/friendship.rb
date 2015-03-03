class Friendship < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :friend, class_name: "User", foreign_key: :friend_id

	def full_name
		[user.first_name, user.last_name].join(" ")
	end

	def device_avtar_id
		user.device_avtar_id
	end

	def friend_token
		friend.login_token
	end

end