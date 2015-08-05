class Api::V1::GameRequestsController < Api::V1::ApplicationController

  before_action :find_game_request, only: [:update, :destroy]
  
	def create
		accepted = params[:accepted] ? params[:accepted] : false
    @game_request = current_user.revenges_sent.build(requested_to_token: params[:requested_token], invitation_type: params[:invitation_type], accepted: accepted, club_config_id: params[:club_config_id])
    if @game_request.save
      render json: {
        success: true,
        id: @game_request.id
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

  def destroy
    if @game_request.destroy
      render json: {
        success: true
      }
    else
      render json: {
        success: false,
        errors: @game_request.errors.full_messages.join(", ")
      }
    end
  end

  def play_latter
    if @game_request.user_id == User.fetch_by_login_token(params[:login_token]).id
      if @game_request.update_attributes(acceptance_by_user_at: Time.zone.now)
        render json: {
          success: true
        }
      else
        render json: {
          success: false
        }
      end
    elsif @game_request.requested_to == User.fetch_by_login_token(params[:login_token]).id
      if @game_request.update_attributes(acceptance_by_requester_at: Time.zone.now)
        render json: {
          success: true
        }
      else
        render json: {
          success: false
        }
      end
    end
  end 

  private

  def current_user
    User.fetch_by_login_token(params[:login_token])
  end

  def find_game_request
    @game_request = GameRequest.where(id: params[:id]).first
  end

end
