class Api::V1::DynamicIapsController < Api::V1::ApplicationController

	def index
		render json: DynamicIap.where(iap_type: params[:type]).first
	end

end