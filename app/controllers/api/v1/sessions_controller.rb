class Api::V1::SessionsController < Api::V1::ApplicationController

	def create
		if params[:fb_id] && params[:device_id]
			if User.where(fb_id: params[:fb_id]).first.blank?
				@guest_user = User.where(device_id: params[:device_id], is_facebook_connected: false).first
				if @guest_user.present?
					@user = @guest_user.dup
					@user.attributes = {parent_id: @guest_user.id, device_id: nil, is_guest: nil, fb_id: params[:fb_id], email: params[:fb_id]+"@facebook.com"}
					if @user.save
						@guest_user.update_attributes(is_facebook_connected: true)
						@success = true
						@new_user = true
					else
						@success = false
						@messages = @user.errors.full_messages.join(", ")
					end
				else
					@success = false
					@messages = "Guest user not present!"
				end
			else
				@user = User.where(fb_id: params[:fb_id]).first
				@user.attributes = {fb_friends_list: params[:fb_friend_list]}
			end
		else
			if params[:fb_id]
				@user = User.where(fb_id: params[:fb_id]).first_or_initialize
				@user.attributes = {fb_friends_list: params[:fb_friend_list]}
				if @user.new_record?
					email = params[:email].present? ? params[:email] : params[:fb_id]+"@facebook.com"
					@user.attributes = {email: email, first_name: params[:first_name], last_name: params[:last_name], fb_friends_list: params[:fb_friend_list]}
					if @user.save
						@success = true
						@new_user = true
					else
						@success = false
						@messages = @user.errors.full_messages.join(", ")
					end
				end
			else
				if params[:email] && params[:password]
					@user = User.where(email: params[:email]).first
					(@user = nil) unless @user.try(:valid_password?, params[:password])
					@success = !@user.blank?
				else
					if params[:is_guest] && params[:device_id]
						@user = User.where(device_id: params[:device_id], is_guest: true).first_or_initialize
						if @user.new_record?
							if @user.save
								@success = true
							else
								@success = false
								@messages = @user.errors.full_messages.join(", ")
							end
						end
					end
				end
			end
		end
		if @user.present?
			login_token = SecureRandom.hex(5)
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
				REDIS_CLIENT.srem("game_players", "game_player:#{params[:id]}")
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