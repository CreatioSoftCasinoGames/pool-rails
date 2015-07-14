class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :find_user, only: [:show, :update, :winner_list, :my_friend_requests, :my_revenge_list, :connect_facebook, :disconnect_facebook, :friend_request_sent, :my_friends, :sent_gift, :received_gift, :ask_for_gift_to, :ask_for_gift_by, :delete_friend]

	def create
		@user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password], first_name: params[:first_name], last_name: params[:last_name], fb_id: params[:fb_id])
		if @user.save
			render json: {
				user: @user,
				valid: true
			}
		else
			render json: {
				user: @user,
				valid: false,
				errors: @user.errors.full_messages.join(", ")
			}
		end
	end

	def show
		render json: @user
	end

	def update
		if @user.update_attributes(user_params)
			render json: {
				user: @user.as_json({
						only: user_params.keys
					}),
				valid: true
			}
		else
			render json: {
				user: @user,
				valid: false,
				errors: @user.errors.full_messages.join(", ")
			}
		end
	end


	def friend_request_sent
    @requests_sent = @user.friend_requests_sent.collect do |friend_request|
    	@user = User.find(friend_request.requested_to_id)
    	{
	    	id: friend_request.id,
	    	user_login_token: User.find(friend_request.user_id).login_token,
	    	requested_token: @user.login_token,
	    	device_avatar_id: @user.device_avatar_id,
	    	full_name: @user.full_name,
	    	image_url: @user.image_url
	    }
    end
    render json: @requests_sent
	end

	def my_friend_requests
    @requests_received = @user.unconfirmed_friend_requests.collect do |friend_request|
    	@user = User.find(friend_request.user_id)
    	{
	    	id: friend_request.id,
	    	user_login_token: User.find(friend_request.requested_to_id).login_token,
	    	requested_token: @user.login_token,
	    	device_avatar_id: @user.device_avatar_id,
	    	full_name: @user.full_name,
	    	image_url: @user.image_url
	    }
    end
    render json: @requests_received
	end

	def my_friends
		if @user.is_fb_connected
			render json: @user.friends.as_json({
				only: [:login_token, :online, :device_avatar_id],
				methods: [:full_name, :image_url]
			})
		else
			render json: @user.buddy_friends.as_json({
				methods: [:full_name, :image_url, :login_token, :online, :device_avtar_id]
			})
		end
	end

	def send_in_game_gift
		render json: InGameGift.all
	end

	def sent_gift
		render json: @user.gift_requests_sent.where(is_asked: false)
	end

	def received_gift
		render json: @user.unconfirmed_gift_requests.where(is_asked: false)
	end

	def ask_for_gift_to
		render json: @user.gift_requests_sent.where(is_asked: true)
	end

	def ask_for_gift_by
		render json: @user.unconfirmed_gift_requests.where(is_asked: true)
	end

	def delete_friend
		@friend = Friendship.where(user_id: @user.id, friend_id: User.fetch_by_login_token(params[:friend_token]).id).first
		if @friend.friend_type == "buddy"
			if @friend.delete
				render json: {success: true}
			else
				render json: {success: false}
			end
		else
			@friend.delete
			Friendship.where(user_id: User.fetch_by_login_token(params[:friend_token]).id, friend_id: @user.id).first.delete
			render json: {
				success: true
			}
		end
	end

	def winner_list
		winner_users = @user.winners.limit(20).collect do |winner|
			{
				login_token: winner.login_token,
				online: winner.online,
				full_name: winner.full_name,
				image_url: winner.image_url,
				can_send_revenge: @user.is_ask_for_revenge(winner.id),
				time_remaining: @user.ask_for_revenge_in(winner.id)
			}
		end
		render json: winner_users
	end
	
	def show
		unless api_current_user.blank?
			@user.is_friend    = api_current_user.friendships.collect(&:friend_id).include?(@user.id)
			@user.is_requested = FriendRequest.where(user_id: [api_current_user.id, @user.id], requested_to_id: [api_current_user.id, @user.id]).present?
		end
		render json: @user
	end

	def opponent_profile
		render json: @user = User.where(login_token:(params[:opponent_id])).first
	end

	def connect_facebook
		@fb_user = User.where(fb_id: params[:fb_id]).first
		if @fb_user.present?
			if @fb_user.update_attributes(fb_id: nil, is_fb_connected: false, first_name: "Guest", last_name: "User")
				@message = "Allready loged in user."
				@login_token = @fb_user.login_token
			else
				@success = false,
				@errors = @fb_user.errors.full_messages.join(", ")
			end
		end
		if @user.update_attributes(fb_id: params[:fb_id], is_fb_connected: true, fb_friends_list: params[:fb_friends_list], first_name: params[:first_name], last_name: params[:last_name])
			@success = true
		else
			@success = false,
			@errors = @user.errors.full_messages.join(", ")
		end
		render json: {
			success: @success,
			message: @message,
			login_token: @login_token,
			errors: @errors
		}
	end

	def disconnect_facebook
		if @user.update_attributes(is_fb_connected: false)
			render json: {
				success: true,
				message: "Successfully disconneted from facebook."
			}
		else
			render json: {
				success: false,
				errors: @user.errors.full_messages.join(", ")
			}
		end
	end

	def my_revenge_list
		@revenges_received = @user.unaccepted_revenge_requests.where(invitation_type: params[:invitation_type]).collect do |revenge_request|
    	@requested_user = User.find(revenge_request.user_id)
    	{
	    	id: revenge_request.id,
	    	invitation_type: revenge_request.invitation_type,
	    	accepted: revenge_request.accepted,
	    	user_login_token: @requested_user.login_token,
	    	requested_token: User.find(revenge_request.requested_to).login_token,
	    	full_name: @requested_user.full_name,
	    	image_url: @requested_user.image_url
	    }
    end
		render json: {
			requests_received: @revenges_received
		}
	end

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :password, :chips, :password_confirmation, :device_avatar_id, :won_count, :lost_count, :rank, :total_coins_won, :win_percentage, :total_tournament_won, :total_tournament_played, :win_streak, :ball_potted, :accuracy, :xp, :current_level, :country, :achievement, :current_coins_balance, :total_games_played, :flag, :user_pool_id)
	end

	def find_user
		@user = User.fetch_by_login_token(params[:id])
		(render json: {message: "User not found", success: false}) if @user.blank?
	end

end








