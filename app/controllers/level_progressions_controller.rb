class LevelProgressionsController < ApplicationController
  before_action :set_level_progression, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @level_progressions = LevelProgression.all
    respond_with(@level_progressions)
  end

  def show
    respond_with(@level_progression)
  end

  def new
    @level_progression = LevelProgression.new
    respond_with(@level_progression)
  end

  def edit
  end

  def create
    @level_progression = LevelProgression.new(level_progression_params)
    @level_progression.save
    respond_with(@level_progression)
  end

  def update
    @level_progression.update(level_progression_params)
    respond_with(@level_progression)
  end

  def destroy
    @level_progression.destroy
    respond_with(@level_progression)
  end

  private
    def set_level_progression
      @level_progression = LevelProgression.find(params[:id])
    end

    def level_progression_params
      params.require(:level_progression).permit(:level, :xp_required_to_clear, :factor_of_increase, :award, :cue_unlocked, :rank)
    end
end
