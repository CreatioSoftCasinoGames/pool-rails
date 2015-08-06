class Api::V1::ClubsController < Api::V1::ApplicationController

	before_action :find_club, only: [:show]

	def index
		render json: Club.all
	end

	def create
		@club = Club.new(club_config_id: params[:club_config_id])
		@club_type = ClubConfig.where(id: params[:club_config_id]).first.club_type

		if @club.save
			render json: {
				club: @club.as_json({
					only: [:id, :name, :entry_fees, :winner_amount, :club_config_id]
					}),
				valid: true,
				club_type: @club_type
			}
		else
			render json: {
				errors: @club.errors.full_messages.join(", "),
				valid: false
			}
		end
	end

	def show
		render json: @club
	end

	private

	def find_club
		@club = Club.where(id: params[:id]).first
		(render json: {message: "Club not found", success: false}) if @club.blank?
	end

end