class Api::V1::UsersController < Api::V1::ApplicationController

	before_action :find_user, only: [:show, :update, :my_friend_requests, :friend_request_sent, :my_friends]

  # def index
  # 	render json:  @user = User.all 
  # end

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
		render json: @user.friend_requests_sent.where(confirmed: false)
	end

	def my_friend_requests
		render json: @user.unconfirmed_friend_requests.where(confirmed: false)
	end

	def my_friends
		render json: @user.friends.as_json({
			only: [:login_token, :online],
			methods: [:full_name, :image_url]
		})
	end

	def delete_friend
		@friend = Friendship.where(user_id: @user.id, friend_id: User.fetch_by_login_token(params[:friend_token])).first.delete
		@friend1 = Friendship.where(user_id: User.fetch_by_login_token(params[:friend_token]), friend_id: @user.id).first.delete
		render json: {
			success: true
		}
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

	private

	def user_params
		params.require(:user).permit(:first_name, :last_name, :password, :chips, :password_confirmation, :device_avatar_id, :won_count, :lost_count, :rank, :total_coins_won, :win_percentage, :total_tournament_won, :total_tournament_played, :win_streak, :ball_potted, :accuracy, :xp, :current_level, :country, :achievement, :current_coins_balance, :total_games_played, :flag)
	end

	def find_user
		@user = User.fetch_by_login_token(params[:id])
		(render json: {message: "User not found", success: false}) if @user.blank?
	end

end