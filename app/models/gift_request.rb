class GiftRequest < ActiveRecord::Base
	belongs_to :user
	has_many :gift_requests_sent
	validate :search_requested_friend, on: :create
	validate :valid_request, on: :create
	validate :send_once, on: :create
	validate :max_send, on: :create
	validate :credit_gift

	belongs_to :reciever, class_name: "User", foreign_key: "send_to_id"

	attr_accessor :send_token

	def user_login_token
		user.login_token
	end

	def send_to_token
		reciever.login_token
	end

	def full_name
		[user.first_name, user.last_name].join(" ")
	end

	def image_url
		user.image_url
	end

	private

	def search_requested_friend
		send_to = User.fetch_by_login_token(send_token)
		unless send_to.blank?
			self.send_to_id = send_to.id
		else
			self.errors.add(:base, "Send to user not present!")
		end
	end

	def valid_request
		if Friendship.where(user_id: user_id, friend_id: send_to_id).blank?
			self.errors.add(:base, "This user is not your friend!")
		end
	end

	def send_once
		gift_sent = GiftRequest.where(user_id: user_id, send_to_id: send_to_id).last
		if gift_sent.present?
			if gift_sent.created_at.to_date == Time.now.to_date
				self.errors.add(:base, "Request already sent, please send after 24 hours!")
			end
		end
	end

	def max_send
		at_begin = Time.now.beginning_of_day
		at_end = at_begin + 1.day
		if user.gift_requests_sent.where("created_at >= ? and created_at <= ?", at_begin, at_end).count() >= 50
			self.errors.add(:base, "You can not send more than 50 gifts in a day!")
		end
	end

	def credit_gift
		if self.changes.include?(:confirmed)
			if gift_type == "coins"
				gift_coins = reciever.coins + gift_value
				self.reciever.update_attributes(coins: gift_coins)
			elsif gift_type == "tickets"
				tickets = reciever.ticket_bought + gift_value
				self.reciever.update_attributes(ticket_bought: tickets)
			elsif gift_type == "powerups"
				powerups = reciever.powerups_remaining + gift_value
				self.reciever.update_attributes(powerups_remaining: powerups)
			end
		end
	end

end
