class GameRequest < ActiveRecord::Base
	belongs_to :user
	belongs_to :game
	belongs_to :requested, foreign_key: :requested_to, class_name: "User"
	validate :search_requested_user, on: :create
	after_update :disable_game_request
	after_create :publish_challenge
	validate :send_once, on: :create

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

	def disable_game_request
		p "==============================================called================================"
		p self
		p "====================================================================================="
		REDIS_CLIENT.PUBLISH("challenge", {
			publish_type: "challenge",
			id: self.id,
			invitation_type: self.invitation_type,
			club_config_id: self.club_config_id,
			accepted: self.accepted, 
			user_login_token: user.login_token,
			requested_token: requested_to_token,
			full_name: full_name,
			image_url: image_url,
			online: requested.online,
			device_avatar_id: requested.device_avatar_id,
			unique_id: requested.unique_id
		}.to_json)
		if self.acceptance_by_requester_at && self.acceptance_by_user_at
			p "------------------------------------------called--------------------------------------"
			self.update_attributes(accepted: true)
		end
	end

	def publish_challenge
		p "=============================Called Create=================================="
		p self
		p full_name
		p requested_token
		p "============================================================================"
    REDIS_CLIENT.PUBLISH("challenge", {
      publish_type: "challenge",
      id: self.id,
			invitation_type: self.invitation_type,
			club_config_id: self.club_config_id, 
			user_login_token: user_login_token,
			requested_token: requested_token,
			full_name: full_name,
			image_url: image_url,
			online: requested.online,
			device_avatar_id: requested.device_avatar_id,
			unique_id: requested.unique_id
    }.to_json)
  end

  def send_once
  	p "________________________________________________________________________________________________________"
  	p user_id
  	p requested_to
  	p "________________________________________________________________________________________________________"
		revenge_sent = GameRequest.where(user_id: user_id, requested_to: requested_to).last
		if revenge_sent.present?
			if revenge_sent.created_at.to_date == Time.now.to_date
				self.errors.add(:base, "Request already sent, please send after 24 hours!")
			end
		end
	end

end
