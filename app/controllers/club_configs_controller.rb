class ClubConfigsController < ApplicationController
  before_action :set_club_config, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if params[:club_type]
      @club_configs = ClubConfig.where(club_type: params[:club_type])
    else
      @club_configs = ClubConfig.all
    end
    respond_with(@club_configs)
  end

  def show
    respond_with(@club_config)
  end

  def new
    @club_config = ClubConfig.new
    respond_with(@club_config)
  end

  def edit
  end

  def create
    @club_config = ClubConfig.new(club_config_params)
    @club_config.save
    respond_with(@club_config)
  end

  def update
    @club_config.update(club_config_params)
    respond_with(@club_config)
  end

  def destroy
    @club_config.destroy
    respond_with(@club_config)
  end

  private
    def set_club_config
      @club_config = ClubConfig.find(params[:id])
    end

    def club_config_params
      params.require(:club_config).permit(:name, :entry_fees, :winner_amount, :club_type, :rule_id , :active, :winner_xp, :looser_xp)
    end
end
