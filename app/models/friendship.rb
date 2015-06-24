class Friendship < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :friend, class_name: "User", foreign_key: :friend_id
	validate :find_user, on: :create
	validate :friend_user, on: :create
	validate :valid_friend
	attr_accessor :user_token, :friend_token

	def full_name
		[user.first_name, user.last_name].join(" ")
	end

	def device_avtar_id
		user.device_avtar_id
	end

	def friend_token
		friend.login_token
		# User.where(friend_id: self.friend_id).first.login_token
	end

	def online
		friend.online
		# User.where(friend_id: self.friend_id).first.online
	end

	private

	def find_user
		if user_token
			user_request = User.fetch_by_login_token(login_token)
			if user_request.present?
				self.user_id = user_request.id
			else
				self.errors.add(:base, "User not found!")
			end
		end
	end

	def friend_user
		if friend_token
			friend_user = User.fetch_by_login_token(friend_token)
			if friend_user.present?
				self.friend_id = friend_user.id
			else
				self.errors.add(:base, "Friend user not present!")
			end
		end
	end

	def valid_friend
		if Friendship.where(user_id: self.user_id, friend_id: self.friend_id).present?
			self.errors.add(:base, "Already added")
		end
	end

end