class Api::V1::SessionsController < Api::V1::ApplicationController

	def create
		if params[:fb_id] && params[:device_id]
			p "--------------------------3---------------------------------"
			if User.where(fb_id: params[:fb_id]).first.blank?
				p "--------------------------4---------------------------------"
				@guest_user = User.where(device_id: params[:device_id]).first
				if @guest_user.present? && !@guest_user.is_fb_connected 
					p "--------------------------5---------------------------------"
					if @guest_user.update_attributes({device_id: params[:device_id], is_guest: false, fb_id: params[:fb_id], email: params[:fb_id]+"@facebook.com", fb_friends_list: params[:fb_friends_list], is_fb_connected: true})
						@success = true
						@user = @guest_user
					else
						@success = false
						@messages = @user.errors.full_messages.join(", ")
					end
				elsif @guest_user.present? && @guest_user.is_fb_connected
					p "--------------------------6---------------------------------"
					@new_user = true
					@success = false
					@message = "Guest User associated with other fb"
				else
					p "--------------------------7---------------------------------"
					@user = User.new({fb_id: params[:fb_id], device_id: params[:device_id], is_guest: false, is_fb_connected: true, email: params[:fb_id]+"@facebook.com", fb_friends_list: params[:fb_friends_list]})
					if @user.save
						@success = true
					else
						@success = false
						@message = @user.errors.full_messages.join(", ")
					end
				end
			else
				p "--------------------------8---------------------------------"
				@guest_user = User.where(device_id: params[:device_id], fb_id: params[:fb_id]).first
				if @guest_user.present?
					p "--------------------------9---------------------------------"
					@success = true
					@new_user = false
					@user = @guest_user
				else
					@success = false
					@new_user = false
					@device_id = User.where(fb_id: params[:fb_id]).first.device_id
					@message = "Progress already exists"
				end
			end
		elsif params[:is_guest] && params[:device_id]
			p "--------------------------1---------------------------------"
			@user = User.where(device_id: params[:device_id], is_guest: true).first_or_initialize
			if @user.new_record?
				p "---------------------------2--------------------------------"
				if @user.save
					@success = true
				else
					@success = false
					@message = @user.errors.full_messages.join(", ")
				end
			else
				@success = true
				@user = @user
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

		if @success
			login_token = SecureRandom.hex(5)
			if params[:first_name]
				@user.update_attributes(first_name: params[:first_name], last_name: params[:last_name])
			end
			if @user.update_attributes(login_token: login_token, online: true, country: params[:country], login_histories_attributes: {id: nil, active: true, login_token: login_token })
				REDIS_CLIENT.PUBLISH("online", {publish_type: "online", online: true, unique_id: @user.unique_id, friends_token: @user.my_friends.collect(&:user).collect(&:login_token), challengers_token: @user.revenges_sent.collect(&:requested).collect(&:login_token) }.to_json)
				render json: @user.as_json({
					only: [ :id, :current_level, :xp, :login_token, :current_coins_balance, :unique_id,:device_id, :is_dummy, :device_avatar_id,
						:won_count, :total_games_played, :total_tournament_won, :ball_potted, :total_tournament_played, :rank, :cue_owned, :is_fb_connected],
          methods: [:full_name, :image_url, :xp_required_to_finish_level, :level_required_to_clear_rank]
				})
			else
				render json: {
					errors: @user.errors.full_messages.join(", "),
					success: false
				}
			end
		else
			render json: {
				success: @success,
				errors: @message,
				device_id: @device_id,
				new_user: @new_user
			}
		end
	end

	def destroy
		@user = User.fetch_by_login_token(params[:id])
		if @user.present?
			login_history_id = @user.login_histories.where(login_histories: {login_token: params[:id]}).first.id
			if @user.update_attributes(online: false, login_histories_attributes: {id: login_history_id ,active: false})
				# REDIS_CLIENT.srem("game_players", "game_player:#{params[:id]}")
				REDIS_CLIENT.PUBLISH("online", {publish_type: "online", online: false, unique_id: @user.unique_id, friends_token: @user.my_friends.collect(&:user).collect(&:login_token), challengers_token: @user.revenges_sent.collect(&:requested).collect(&:login_token) }.to_json)
				render json: {
					success: true,
					message: "You have been signed out successfully!"
				}
			else
				render json: {
					errors: @user.errors.full_messages.join(", "),
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
