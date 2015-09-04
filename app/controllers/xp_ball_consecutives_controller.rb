class XpBallConsecutivesController < ApplicationController
  before_action :set_xp_ball_consecutive, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @xp_ball_consecutives = XpBallConsecutive.all
    respond_with(@xp_ball_consecutives)
  end

  def show
    respond_with(@xp_ball_consecutive)
  end

  def new
    @xp_ball_consecutive = XpBallConsecutive.new
    respond_with(@xp_ball_consecutive)
  end

  def edit
  end

  def create
    @xp_ball_consecutive = XpBallConsecutive.new(xp_ball_consecutive_params)
    @xp_ball_consecutive.save
    respond_with(@xp_ball_consecutive)
  end

  def update
    @xp_ball_consecutive.update(xp_ball_consecutive_params)
    respond_with(@xp_ball_consecutive)
  end

  def destroy
    @xp_ball_consecutive.destroy
    respond_with(@xp_ball_consecutive)
  end

  private
    def set_xp_ball_consecutive
      @xp_ball_consecutive = XpBallConsecutive.find(params[:id])
    end

    def xp_ball_consecutive_params
      params.require(:xp_ball_consecutive).permit(:room_type, :twoball, :threeball, :fourball, :fiveball, :sixball, :sevenball)
    end
end
