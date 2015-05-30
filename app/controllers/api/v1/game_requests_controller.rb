class Api::V1::GameRequestsController < Api::V1::ApplicationController


	def create
		accepted = params[:accepted]? params[:accepted] : false
    @game_request = GameRequest.new(requested_from_token: params[:requested_from], requested_to_token: params[:requested_to], invitation_type: params[:invitation_type], accepted: accepted)
    if @game_request.save
      render json: @game_request 
    else
      render json: {
				errors: @game_request.errors.full_messages.join
			}
    end
  end

  def update
  	@game_request = GameRequest.find(params[:id])
    if @game_request.update(accepted: params[:accepted])
    	render json: @game_request 
  	else
	    render json: {
	      errors: @game_request.errors.full_messages.join,
	      success: false
	    }
    end
  end 



end
