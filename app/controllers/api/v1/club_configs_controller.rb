class Api::V1::ClubConfigsController < Api::V1::ApplicationController

	def index
		render json: ClubConfig.all
	end

end

