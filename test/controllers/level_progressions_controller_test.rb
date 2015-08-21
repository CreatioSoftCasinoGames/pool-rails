require 'test_helper'

class LevelProgressionsControllerTest < ActionController::TestCase
  setup do
    @level_progression = level_progressions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:level_progressions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create level_progression" do
    assert_difference('LevelProgression.count') do
      post :create, level_progression: { award: @level_progression.award, cue_unlocked: @level_progression.cue_unlocked, factor_of_increase: @level_progression.factor_of_increase, level: @level_progression.level, rank: @level_progression.rank, xp_required_to_clear: @level_progression.xp_required_to_clear }
    end

    assert_redirected_to level_progression_path(assigns(:level_progression))
  end

  test "should show level_progression" do
    get :show, id: @level_progression
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @level_progression
    assert_response :success
  end

  test "should update level_progression" do
    patch :update, id: @level_progression, level_progression: { award: @level_progression.award, cue_unlocked: @level_progression.cue_unlocked, factor_of_increase: @level_progression.factor_of_increase, level: @level_progression.level, rank: @level_progression.rank, xp_required_to_clear: @level_progression.xp_required_to_clear }
    assert_redirected_to level_progression_path(assigns(:level_progression))
  end

  test "should destroy level_progression" do
    assert_difference('LevelProgression.count', -1) do
      delete :destroy, id: @level_progression
    end

    assert_redirected_to level_progressions_path
  end
end
