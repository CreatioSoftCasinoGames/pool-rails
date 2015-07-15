class Api::V1::FriendshipsController < Api::V1::ApplicationController

	#skip_before_filter :authenticate_user
	
	def create
		@friend = Friendship.new(user_token: params[:login_token], friends_token: params[:friend_token], friend_type: "buddy")
		if @friend.save
			render json: {
				success: true
			}
			# user = User.fetch_by_login_token(params[:friend_token])
			# p user
			# REDIS_CLIENT.PUBLISH("friend_added", {
			# 	publish_type: "friend_added", 
			# 	login_token: params[:login_token], 
			# 	friend_token: params[:friend_token],
			# 	full_name: user.full_name,
			# 	image_url: user.image_url,
			# 	is_online: user.online,
			# 	device_avatar_id: user.device_avatar_id
			# }.to_json)
		else
			render json: {
				success: false,
				errors: @friend.errors.full_messages.join
			}
		end
	end

	def update
		@friend = Friendship.find(params[:id])
		if @friend.update_attributes(friend_params)
			render json: @friend
		else
			render json: {
				errors: @friend.errors.full_messages.join(", ")
			}
		end
	end

	def show
		@friend = Friendship.where(user_id: params[:id]).all
		render json: @friend
	end

end