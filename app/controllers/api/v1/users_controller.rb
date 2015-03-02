class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :find_user, only: [:show, :update]

	def create
		params[:password] = "temp1234" if params[:password].blank?
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

	# def friend_request_sent
	# 	@friend_requests = @user.friend_requests.where(confirmed: false)
	# 	render json: @friend_requests
	# end

	# def my_friend_requests
	# 	user_id = @user.id
	# 	@friend_requests = FriendRequest.where(requested_to_id: user_id, confirmed: false)
	# 	render json: @friend_requests
	# end

	# def send_in_game_gift
	# 	@in_game_gifts = InGameGift.all
	# 	render json: @in_game_gifts
	# end

	# def my_friends
	# 	render json: @user.friends.as_json({
	# 		only: [:login_token, :online, :device_avatar_id],
	# 		methods: [:full_name, :image_url]
	# 	})
	# end

	# def delete_friend
	# 	@friend = Friendship.where(user_id: @user.id, friend_id: User.fetch_by_login_token(params[:friend_token])).first.delete
	# 	@friend1 = Friendship.where(user_id: User.fetch_by_login_token(params[:friend_token]), friend_id: @user.id).first.delete
	# 	render json: {
	# 		success: true
	# 	}
	# end

	# def gift_sent
	# 	@sent_gift = @user.gift_requests.where(is_requested: false)
	# 	render json: @sent_gift
	# end

	# def gift_received
	# 	render json: @user.unconfirmed_gift_requests
	# end

	# def asked_for_gift_to
	# 	@gift_asked_to = @user.gift_requests.where(is_requested: true)
	# 	render json: @gift_asked_to
	# end

	# def asked_for_gift_by
	# 	@gift_asked_by = @user.gift_requests.where(is_requested: true)
	# 	render json: @gift_asked_by
	# end
	
	def show
		unless api_current_user.blank?
			@user.is_friend    = api_current_user.friendships.collect(&:friend_id).include?(@user.id)
			@user.is_requested = FriendRequest.where(user_id: [api_current_user.id, @user.id], requested_to_id: [api_current_user.id, @user.id]).present?
		end
		render json: @user
	end

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :password, :chips, :password_confirmation, :image, :fb_id, :email, :device_avatar_id, :shootout_level, :diamonds, :xp, :level_precentage, fb_friend_list: [])
	end

	def find_user
		@user = User.where(login_token: params[:id]).first
		(render json: {message: "User not found", success: false}) if @user.blank?
	end

end