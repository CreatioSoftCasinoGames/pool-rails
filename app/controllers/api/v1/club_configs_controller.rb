class Api::V1::ClubConfigsController < Api::V1::ApplicationController

	def index
		if params[:club_type].capitalize == "Tournament" 
		  render json: ClubConfig.where(club_type: "Tournament")
		else
			render json: ClubConfig.where(club_type: "OneToOne")
		end
	end

end

