class Game < ActiveRecord::Base
	belongs_to :club
	belongs_to :user
	has_many :game_requests
	belongs_to :winner, class_name: "User"
	before_create :set_winner_and_looser
	attr_accessor :winner_token, :looser_token

	def full_name
		[winner.first_name, winner.last_name].join(" ")
	end

	def device_avatar_id
		winner.device_avatar_id
	end

	def friend_token
		friend.login_token
		# User.where(friend_id: self.friend_id).first.login_token
	end

	def online
		friend.online
		# User.where(friend_id: self.friend_id).first.online
	end


  # def avatar
  #   self.image? ? image.url(:avatar) : nil
  # end

  def image_url 
    if fb_id
      "http://graph.facebook.com/#{fb_id}/picture?height=200"
    end
  end

	private

	def set_winner_and_looser
		if winner_token && looser_token
			self.winner_id = User.fetch_by_login_token(winner_token).id
			self.looser_id = User.fetch_by_login_token(looser_token).id
		end
	end

end
