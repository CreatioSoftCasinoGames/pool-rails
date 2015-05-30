class Api::V1::FriendRequestsController < Api::V1::ApplicationController

	before_action :get_friend_requests, only: [:show, :destroy, :update]

	def create
		@friend_request = current_user.friend_requests_sent.build(requested_token: params[:requested_token])
		if @friend_request.save
			render json: @friend_request
		else
			render json: {
				errors: @friend_request.errors.full_messages.join(", "),
				success: false
			}
		end
	end

	def update
		if @friend_request.update_attributes(friend_request_params)
			render json: @friend_request
		else
			render json: {
				errors: @friend_request.errors.full_messages.join,
				success: false
			}
		end
	end

	def destroy
		@friend_request.destroy
		render json:{
			message: "Friend Request deleted!",
			success: true
		}
	end

	def show
		render json: @friend_request
	end

	private

	def current_user
		User.find_by_login_token(params[:login_token])
	end

	def friend_request_params
		params.require(:friend_request).permit(:confirmed)
	end

	def get_friend_requests
		@friend_request = FriendRequest.where(id: params[:id]).first
		(render json: {message: "Friend request not found!", success: false}) if @friend_request.blank?
	end

end