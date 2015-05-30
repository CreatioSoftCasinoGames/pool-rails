class GameRequest < ActiveRecord::Base
	belongs_to :user
	belongs_to :game
	before_create :get_id_from_token
	attr_accessor :requested_from_token, :requested_to_token
  
  private
  
	def get_id_from_token
		if requested_from_token && requested_to_token
			self.requested_from = User.fetch_by_login_token(requested_from_token).id
			self.requested_to = User.fetch_by_login_token(requested_to_token).id
		end
	end

end
