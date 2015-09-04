class XpBallPottedOnWinningsController < ApplicationController
  before_action :set_xp_ball_potted_on_winning, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @xp_ball_potted_on_winnings = XpBallPottedOnWinning.all
    respond_with(@xp_ball_potted_on_winnings)
  end

  def show
    respond_with(@xp_ball_potted_on_winning)
  end

  def new
    @xp_ball_potted_on_winning = XpBallPottedOnWinning.new
    respond_with(@xp_ball_potted_on_winning)
  end

  def edit
  end

  def create
    @xp_ball_potted_on_winning.save
    respond_with(@xp_ball_potted_on_winning)
  end

  def update
    @xp_ball_potted_on_winning.update(xp_ball_potted_on_winning_params)
    respond_with(@xp_ball_potted_on_winning)
  end

  def destroy
    @xp_ball_potted_on_winning.destroy
    respond_with(@xp_ball_potted_on_winning)
  end

  private
    def set_xp_ball_potted_on_winning
      @xp_ball_potted_on_winning = XpBallPottedOnWinning.find(params[:id])
    end

    def xp_ball_potted_on_winning_params
      params.require(:xp_ball_potted_on_winning).permit(:room_type, :oneball, :twoball, :threeball, :fourball, :fiveball, :sixball, :sevenball)
    end
end
