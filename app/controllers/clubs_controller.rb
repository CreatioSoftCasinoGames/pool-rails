class ClubsController < ApplicationController
  before_action :set_club, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @clubs = Club.all
    respond_with(@clubs)
  end

  def show
    respond_with(@club)
  end

  def new
    @club = Club.new
    respond_with(@club)
  end

  def edit
  end

  def create
    @club = Club.new(club_params)
    @club.save
    respond_with(@club)
  end

  def update
    @club.update(club_params)
    respond_with(@club)
  end

  def destroy
    @club.destroy
    respond_with(@club)
  end

  private
    def set_club
      @club = Club.find(params[:id])
    end

    def club_params
      params.require(:club).permit(:name, :entry_fees, :winner_amount, :club_config_id)
    end
end
