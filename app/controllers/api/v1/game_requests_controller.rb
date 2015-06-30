class Api::V1::GameRequestsController < Api::V1::ApplicationController


	def create
		accepted = params[:accepted]? params[:accepted] : false
    @game_request = current_user.revenges_sent.build(requested_to_token: params[:requested_token], invitation_type: params[:invitation_type], accepted: accepted)
    if @game_request.save
      render json: {
        success: true
      }
    else
      render json: {
        success: false,
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

  private

  def current_user
    User.fetch_by_login_token(params[:login_token])
  end

end
