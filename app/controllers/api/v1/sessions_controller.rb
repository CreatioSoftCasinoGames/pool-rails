class Api::V1::SessionsController < Api::V1::ApplicationController

	def create
		# game_version = GameVersion.where(device_type: params[:device], version: params[:game_version]).first
		# update_required = game_version.present? ? game_version.require_update : true
		if params[:fb_id] && params[:device_id]
			if User.where(fb_id: params[:fb_id]).first.blank?
				@guest_user = User.where(device_id: params[:device_id], is_fb_connected: false).first
				if @guest_user.present?
					@user = @guest_user.dup
					@user.attributes = {parent_id: @guest_user.id, device_id: params[:device_id], is_guest: false, fb_id: params[:fb_id], email: params[:fb_id]+"@facebook.com", fb_friends_list: params[:fb_friends_list], is_fb_connected: true}
					if @user.save
						@guest_user.update_attributes(is_fb_connected: true)
						@success = true
						@new_user = true
					else
						@success = false
						@messages = @user.errors.full_messages.join(", ")
					end
				else
					facebook_sync(params)
				end
			else
				facebook_sync(params)
			end
		elsif params[:email] && params[:password]
			@user = User.where(email: params[:email]).first
			(@user = nil) unless @user.valid_password?(params[:password])
			@success = !@user.blank? 
		elsif params[:is_guest] && params[:device_id]
			@user = User.where(device_id: params[:device_id], is_guest: true).first_or_initialize
			if @user.new_record?
				if @user.save
					@success = true
				else
					@success = false
					@message = @user.errors.full_messages.join(", ")
				end
			end
		elsif params[:is_bot]
			@user = User.create(first_name: params[:first_name], last_name: params[:last_name], is_bot: true)
			if @user.save
				@success = true
			else
				@success = false
				@message = @user.errors.full_messages.join(", ")
			end
		end

		if @user.present?
			login_token = SecureRandom.hex(5)
			# login_token = @user.id
			if params[:first_name]
				@user.update_attributes(first_name: params[:first_name], last_name: params[:last_name])
			end
			if @user.update_attributes(login_token: login_token, online: true, country: params[:country], login_histories_attributes: {id: nil, active: true, login_token: login_token })
				REDIS_CLIENT.PUBLISH("friend_online", {publish_type: "friend_online", login_token: @user.login_token, online: true, friends_token: @user.friends.collect(&:login_token)}.to_json)
				# @user.previous_login_token = @user.login_histories.order("created_at desc").limit(2).last.try(:login_token)
				render json: @user.as_json({
					only: [ :id, :current_level, :xp, :login_token, :current_coins_balance, :unique_id,:device_id, :is_dummy, :device_avatar_id,
						:won_count, :total_games_played, :total_tournament_won, :ball_potted, :total_tournament_played, :rank, :cue_owned],
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
				errors: @message,
				success: false
			}
		end
	end

	def destroy
		@user = User.fetch_by_login_token(params[:id])
		if @user.present?
			login_history_id = @user.login_histories.where(login_histories: {login_token: params[:id]}).first.id
			if @user.update_attributes(online: false, login_histories_attributes: {id: login_history_id ,active: false})
				REDIS_CLIENT.srem("game_players", "game_player:#{params[:id]}")
				REDIS_CLIENT.PUBLISH("friend_online", {publish_type: "friend_online", login_token: @user.login_token, online: false, friends_token: @user.friends.collect(&:login_token)}.to_json)
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

	private 

	def facebook_sync(params)
		@user = User.where(fb_id: params[:fb_id]).first_or_initialize
		@user.attributes = {fb_friends_list: params[:fb_friends_list], device_id: params[:device_id]}
		if @user.new_record?
			email = params[:email].present? ? params[:email] : params[:fb_id]+"@facebook.com"
			@user.attributes = {email: email, first_name: params[:first_name], last_name: params[:last_name], fb_friends_list: params[:fb_friends_list], is_fb_connected: true}
			if @user.save
				@success = true
			else
				@success = false
				@message = @user.errors.full_messages.join(" , ")
			end
		else
			@user.update_attributes({first_name: params[:first_name], last_name: params[:last_name], fb_friends_list: params[:fb_friends_list]})
		end
	end

end
