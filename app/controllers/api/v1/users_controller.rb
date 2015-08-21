class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :find_user, only: [:show, :update, :winner_list, :my_friend_requests, :my_revenge_list, :connect_facebook, :disconnect_facebook, :friend_request_sent, :my_friends, :sent_gift, :received_gift, :ask_for_gift_to, :ask_for_gift_by, :delete_friend, :update_points]

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

	def update_points
		if @user.update_attributes(user_params)
			render json: {
				user: @user.as_json({
					only: user_params.keys,
					methods: [:xp_required_to_finish_level]
				}),
				success: true
			}
		else
			render json: {
				success: false,
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
			friends = @user.friends.collect do |friend|
				{
					login_token: friend.login_token,
					online: friend.online,
					current_level: friend.current_level,
					full_name: friend.full_name,
					image_url: friend.image_url,
					device_avatar_id: friend.device_avatar_id,
					unique_id: friend.unique_id,
					can_send_gift: @user.is_ask_for_gift(friend.id),
					send_gift_time_remaining: @user.ask_for_gift_in(friend.id),
					can_challenge: @user.can_challenge(friend.id),
					challenge_time_remaining: @user.ask_for_challenge_in(friend.id),
					allready_challenged_in: @user.challenged_in(friend.id)
				}
			end
		else
			friends = @user.buddy_friends.collect do |buddy_friend|
				{
					login_token: buddy_friend.login_token,
					online: buddy_friend.online,
					current_level: buddy_friend.current_level,
					full_name: buddy_friend.full_name,
					image_url: buddy_friend.image_url,
					device_avatar_id: buddy_friend.device_avatar_id,
					unique_id: buddy_friend.unique_id,
					can_send_gift: @user.is_ask_for_gift(buddy_friend.id),
					send_gift_time_remaining: @user.ask_for_gift_in(buddy_friend.id),
					can_challenge: @user.can_challenge(buddy_friend.id),
					challenge_time_remaining: @user.ask_for_challenge_in(buddy_friend.id),
					allready_challenged_in: @user.challenged_in(buddy_friend.id)
				}
			end
		end
		render json: friends
	end

	def find_friend
		@friend = User.where(unique_id: params[:friend_id]).first
		# @friend.image_url = @friend.image_url.present? ? @friend.image_url : ""

		if @friend.present?
			render json: @friend
		else
			render json: { 
				message: "User not found with this id" 
			}
		end
	end

	def send_in_game_gift
		render json: InGameGift.all
	end

	def sent_gift
		render json: @user.gift_requests_sent.where(is_asked: false)
	end

	def received_gift
	 	gifts_received = @user.gift_requests_sent.where(confirmed: true).collect do |gift|
	  	reciever = User.find(gift.send_to_id)
	  	{
	    	id: gift.id,
	    	user_login_token: @user.login_token,
	    	send_to_token: reciever.login_token,
	    	gift_type: gift.gift_type,
	    	gift_value: gift.gift_value,
	    	is_asked: gift.is_asked,
	    	confirmed: gift.confirmed,
	    	full_name: reciever.full_name,
	    	image_url: reciever.image_url,
	    	device_avatar_id: reciever.device_avatar_id
	  	}
	 	end
	 render json: gifts_received
 end

	def ask_for_gift_to
		render json: @user.gift_requests_sent.where(is_asked: true)
	end

	def ask_for_gift_by
		render json: @user.unconfirmed_gift_requests.where(is_asked: true)
	end

	def delete_friend
		@friend = Friendship.where(user_id: @user.id, friend_id: User.fetch_by_login_token(params[:friend_token]).id).first
		if @friend.present?
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
		else
			render json: {
				success: false
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
		render json: User.where(login_token:(params[:opponent_id])).first
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
		@revenges_received = @user.unaccepted_revenge_requests.where("invitation_type = ? AND created_at >= ?",  params[:invitation_type], Time.zone.now - 24.hours).collect do |revenge_request|
		@requested_user = User.find(revenge_request.user_id)
		{
    	id: revenge_request.id,
    	invitation_type: revenge_request.invitation_type,
    	accepted: revenge_request.accepted,
    	club_config_id: revenge_request.club_config_id,
    	user_login_token: @requested_user.login_token,
    	requested_token: User.find(revenge_request.requested_to).login_token,
    	full_name: @requested_user.full_name,
    	image_url: @requested_user.image_url,
    	online: @requested_user.online,
    	device_avatar_id: @requested_user.device_avatar_id,
    	unique_id: @requested_user.unique_id
    }
    end
		render json: @revenges_received
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








