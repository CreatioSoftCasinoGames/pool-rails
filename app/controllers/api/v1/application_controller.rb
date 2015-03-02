class Api::V1::ApplicationController < ApplicationController

	skip_before_filter :verify_authenticity_token
	before_filter :restrict_access

	def default_serializer_options
	  {root: false}
	end

	private

	def restrict_access
	  api_key = ApiKey.where(token: params[:token], active: true).first
	  head :unauthorized unless api_key
	end

end