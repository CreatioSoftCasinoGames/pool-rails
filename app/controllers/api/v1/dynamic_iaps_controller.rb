class Api::V1::DynamicIapsController < Api::V1::ApplicationController

	def index
		render json: DynamicIap.where(country: params[:country]).first
	end

end