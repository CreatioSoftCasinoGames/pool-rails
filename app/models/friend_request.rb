class FriendRequest < ActiveRecord::Base
	belongs_to :user
	belongs_to :requested_to, foreign_key: :requested_to_id, class_name: "User"
	has_many :friend_requests_sent
	before_update :update_friend
	validate :search_requested_friend, on: :create
	validate :valid_request, :on => :create
	attr_accessor :requested_token

	def image_url
		requested_to.image_url
	end

	def user_login_token
		user.login_token
	end

	def requested_to_token
		requested_to.login_token
	end

	def full_name
    [user.first_name, user.last_name].join(" ")
  end

	private

	def search_requested_friend
		requested_to = User.find_by_login_token(requested_token)
		unless requested_to.blank?	
			self.requested_to_id = requested_to.id
		else
			self.errors.add(:base, "Requested User not present")
		end
	end

	def valid_request
		if FriendRequest.where(user_id: [user_id, requested_to_id], requested_to_id: [user_id, requested_to_id]).present?
			self.errors.add(:base, "Already requested friend")
		end
	end

	def update_friend
		if self.changes.include?(:confirmed)
			Friendship.create(user_id: self.user_id, friend_id: self.requested_to_id)
			Friendship.create(friend_id: self.user_id, user_id: self.requested_to_id)
		end
	end

end