class Friendship < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :friend, class_name: "User", foreign_key: :friend_id
	validate :find_user, on: :create
	validate :friend_user, on: :create
	validate :valid_friend
	after_create :publish_friend
	attr_accessor :user_token, :friends_token

	def full_name
		[friend.first_name, friend.last_name].join(" ")
	end

	def device_avatar_id
		friend.device_avatar_id
	end

	def login_token
		friend.login_token
	end

	def image_url
		friend.image_url
	end

	def friend_token
		friend.login_token
		# User.where(friend_id: self.friend_id).first.login_token
	end

	def online
		friend.online
		# User.where(friend_id: self.friend_id).first.online
	end

	def unique_id
		friend.unique_id
	end

	private

	def find_user
		if user_token
			user_request = User.fetch_by_login_token(user_token)
			if user_request.present?
				self.user_id = user_request.id
			else
				self.errors.add(:base, "User not found!")
			end
		end
	end

	def friend_user
		if friends_token
			friend_user = User.fetch_by_login_token(friends_token)
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

	def publish_friend
		p "=================================================="
		friend = User.find(friend_id)
		p friend
		user = User.find(user_id)
		p user
		REDIS_CLIENT.PUBLISH("friend_added", {
			publish_type: "friend_added", 
			login_token: user.login_token,
			friend_token: friend.login_token,
			full_name: friend.full_name,
			image_url: friend.image_url,
			is_online: friend.online,
			device_avatar_id: friend.device_avatar_id
		}.to_json)
	end

end