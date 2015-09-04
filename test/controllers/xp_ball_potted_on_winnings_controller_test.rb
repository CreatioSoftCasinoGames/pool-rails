require 'test_helper'

class XpBallPottedOnWinningsControllerTest < ActionController::TestCase
  setup do
    @xp_ball_potted_on_winning = xp_ball_potted_on_winnings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:xp_ball_potted_on_winnings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create xp_ball_potted_on_winning" do
    assert_difference('XpBallPottedOnWinning.count') do
      post :create, xp_ball_potted_on_winning: { fiveball: @xp_ball_potted_on_winning.fiveball, fourball: @xp_ball_potted_on_winning.fourball, oneball: @xp_ball_potted_on_winning.oneball, sevenball: @xp_ball_potted_on_winning.sevenball, sixball: @xp_ball_potted_on_winning.sixball, threeball: @xp_ball_potted_on_winning.threeball, twoball: @xp_ball_potted_on_winning.twoball }
    end

    assert_redirected_to xp_ball_potted_on_winning_path(assigns(:xp_ball_potted_on_winning))
  end

  test "should show xp_ball_potted_on_winning" do
    get :show, id: @xp_ball_potted_on_winning
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @xp_ball_potted_on_winning
    assert_response :success
  end

  test "should update xp_ball_potted_on_winning" do
    patch :update, id: @xp_ball_potted_on_winning, xp_ball_potted_on_winning: { fiveball: @xp_ball_potted_on_winning.fiveball, fourball: @xp_ball_potted_on_winning.fourball, oneball: @xp_ball_potted_on_winning.oneball, sevenball: @xp_ball_potted_on_winning.sevenball, sixball: @xp_ball_potted_on_winning.sixball, threeball: @xp_ball_potted_on_winning.threeball, twoball: @xp_ball_potted_on_winning.twoball }
    assert_redirected_to xp_ball_potted_on_winning_path(assigns(:xp_ball_potted_on_winning))
  end

  test "should destroy xp_ball_potted_on_winning" do
    assert_difference('XpBallPottedOnWinning.count', -1) do
      delete :destroy, id: @xp_ball_potted_on_winning
    end

    assert_redirected_to xp_ball_potted_on_winnings_path
  end
end
