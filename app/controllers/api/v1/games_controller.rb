class Api::V1::GamesController < Api::V1::ApplicationController

	def create
    @game = Game.new(club_config_id: params[:club_config_id], winner_token: params[:winner_id], looser_token: params[:looser_id])
    if @game.save
      render json: @game 
    else
      render json: {
				errors: @game.errors.full_messages.join
			}
    end
  end

  def player_list
  	@player_list = Game.where(looser_id: params[:looser_id]).limit(20).collect(&:winner_id)
  	render :json => User.where(id: @player_list).as_json({
      only: [:login_token, :device_avatar_id],
      methods: [:full_name, :image_url]
    })
  end

end
