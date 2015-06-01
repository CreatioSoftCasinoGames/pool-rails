class Api::V1::ClientBugsController < Api::V1::ApplicationController

	def create
	  @client_bug = ClientBug.new(exception: params[:exception], bug_type: params[:bug_type])
    if @client_bug.save
      render json: {
      	success: true
      }
    else
      render json: {
				success: false,
				message: @client_bug.errors.full_messages.join(", ")
			} 
    end
	end

	# def index
	# 	render json: ClientBug.all
	# end

end




