class Api::V1::SessionsController < Api::V1::ApplicationController

	def create
		if params[:fb_id] && params[:device_id]
			if User.where(fb_id: params[:fb_id]).first.blank?
				@guest_user = User.where(device_id: params[:device_id], is_fb_connected: false).first
				if @guest_user.present?
					@user = @guest_user.dup
					@user.attributes = {device_id: params[:device_id], is_guest: false, fb_id: params[:fb_id], email: params[:fb_id]+"@facebook.com", fb_friends_list: params[:fb_friends_list], is_fb_connected: true}
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
			if @user.update_attributes(login_token: login_token, online: true, login_histories_attributes: {id: nil, active: true, login_token: login_token })
				render json: @user
			else
				render json: {
					errors: @messages,
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