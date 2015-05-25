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
  	# @player_details = ""
  	@player_list = Game.all.where(looser_id: params[:looser_id]).limit(20).collect(&:winner_id)

  	@player_list.each do |token|
      if @player_details.blank?
  		  @player_details = User.where(id: token).first
      else
        @player_details = @player_details, User.where(id: token).first
      end
  	end
  	render :json => @player_details.as_json({
      only: [:login_token, :device_avatar_id],
      methods: [:full_name, :image_url]
    })
  end

end

# + User.fetch_by_login_token(@player_list)
# @login = User.all.pluck(:login_token)
#  @login.include? ('winner_id')
#  if true
#  	login_token == winner_id
#  end
