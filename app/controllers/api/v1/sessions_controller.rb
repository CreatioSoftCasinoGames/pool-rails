class Api::V1::SessionsController < Api::V1::ApplicationController

	def create
		if params[:is_guest] && params[:device_id]
			@user = User.where(device_id: params[:device_id], is_guest: true).first_or_initialize
			if @user.new_record?
				if @user.save
					@success = true
				else
					@success = false
					@message = @user.errors.full_messages.join(", ")
				end
			end
		elsif params[:is_dummy]
			@user = User.create(first_name: params[:first_name], last_name: params[:last_name], is_dummy: true)
			if @user.save
				@success = true
			else
				@success = false
				@message = @user.errors.full_messages.join(", ")
			end
		end

		if @user.present?
			login_token = SecureRandom.hex(5)
			if @user.update_attributes(login_token: login_token, online: true, login_histories_attributes: {id: nil, active: true, login_token: login_token })
				# @message = {}
				REDIS_CLIENT.PUBLISH("friend_online", {publish_type: "friend_online", unique_id: @user.unique_id, friends_token: @user.friends.collect(&:login_token) }.to_json)
				render json: @user.as_json({
					only: [ :id, :current_level, :xp, :login_token, :current_coins_balance, :unique_id,:device_id, :is_dummy, :device_avatar_id,
						:won_count, :total_games_played, :total_tournament_won, :total_tournament_played],
          methods: [:full_name, :image_url]
				}) 
			else
				render json: {
					errors: @user.errors.full_messages.join(", "),
					success: false
				}
			end
		else
			render json: {
				errors: @messages,
				success: false
			}
		end
	end

	def destroy
		@user = User.where(login_token: params[:id]).first
	
		if @user.present?
			login_history_id = @user.login_histories.where(login_histories: {login_token: params[:id]}).first.id
			if @user.update_attributes(online: false, login_histories_attributes: {id: login_history_id ,active: false})
				# REDIS_CLIENT.srem("game_players", "game_player:#{params[:id]}")
				render json: {
					success: true,
					message: "You have been signed out successfully!"
				}
			else
				render json: {
					error: @user.errors.full_messages.join(", "),
					success: false
				}
			end
		else
			render json: {
				success: false,
				message: "Session does not exists"
			}
		end
	end

end
