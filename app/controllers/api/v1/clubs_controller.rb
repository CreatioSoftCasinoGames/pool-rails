class Api::V1::ClubsController < Api::V1::ApplicationController

	def index
		render json: Club.all
	end

end