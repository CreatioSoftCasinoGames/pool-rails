class FriendRequestsController < ApplicationController
  before_action :set_friend_request, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @friend_requests = FriendRequest.all
    respond_with(@friend_requests)
  end

  def show
    respond_with(@friend_request)
  end

  def new
    @friend_request = FriendRequest.new
    respond_with(@friend_request)
  end

  def edit
  end

  def create
    @friend_request = FriendRequest.new(friend_request_params)
    @friend_request.save
    respond_with(@friend_request)
  end

  def update
    @friend_request.update(friend_request_params)
    respond_with(@friend_request)
  end

  def destroy
    @friend_request.destroy
    respond_with(@friend_request)
  end

  private
    def set_friend_request
      @friend_request = FriendRequest.find(params[:id])
    end

    def friend_request_params
      params.require(:friend_request).permit(:requested_to_id, :confirmed, :user_id)
    end
end
