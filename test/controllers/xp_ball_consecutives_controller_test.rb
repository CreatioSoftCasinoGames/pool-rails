require 'test_helper'

class XpBallConsecutivesControllerTest < ActionController::TestCase
  setup do
    @xp_ball_consecutive = xp_ball_consecutives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:xp_ball_consecutives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create xp_ball_consecutive" do
    assert_difference('XpBallConsecutive.count') do
      post :create, xp_ball_consecutive: { fiveball: @xp_ball_consecutive.fiveball, fourball: @xp_ball_consecutive.fourball, sevenball: @xp_ball_consecutive.sevenball, sixball: @xp_ball_consecutive.sixball, threeball: @xp_ball_consecutive.threeball, twoball: @xp_ball_consecutive.twoball }
    end

    assert_redirected_to xp_ball_consecutive_path(assigns(:xp_ball_consecutive))
  end

  test "should show xp_ball_consecutive" do
    get :show, id: @xp_ball_consecutive
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @xp_ball_consecutive
    assert_response :success
  end

  test "should update xp_ball_consecutive" do
    patch :update, id: @xp_ball_consecutive, xp_ball_consecutive: { fiveball: @xp_ball_consecutive.fiveball, fourball: @xp_ball_consecutive.fourball, sevenball: @xp_ball_consecutive.sevenball, sixball: @xp_ball_consecutive.sixball, threeball: @xp_ball_consecutive.threeball, twoball: @xp_ball_consecutive.twoball }
    assert_redirected_to xp_ball_consecutive_path(assigns(:xp_ball_consecutive))
  end

  test "should destroy xp_ball_consecutive" do
    assert_difference('XpBallConsecutive.count', -1) do
      delete :destroy, id: @xp_ball_consecutive
    end

    assert_redirected_to xp_ball_consecutives_path
  end
end
