require 'test_helper'

class OnWinningsControllerTest < ActionController::TestCase
  setup do
    @on_winning = on_winnings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:on_winnings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create on_winning" do
    assert_difference('OnWinning.count') do
      post :create, on_winning: { 1ball: @on_winning.1ball, 2ball: @on_winning.2ball, 3ball: @on_winning.3ball, 4ball: @on_winning.4ball, 5ball: @on_winning.5ball, 6ball: @on_winning.6ball, 7ball: @on_winning.7ball }
    end

    assert_redirected_to on_winning_path(assigns(:on_winning))
  end

  test "should show on_winning" do
    get :show, id: @on_winning
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @on_winning
    assert_response :success
  end

  test "should update on_winning" do
    patch :update, id: @on_winning, on_winning: { 1ball: @on_winning.1ball, 2ball: @on_winning.2ball, 3ball: @on_winning.3ball, 4ball: @on_winning.4ball, 5ball: @on_winning.5ball, 6ball: @on_winning.6ball, 7ball: @on_winning.7ball }
    assert_redirected_to on_winning_path(assigns(:on_winning))
  end

  test "should destroy on_winning" do
    assert_difference('OnWinning.count', -1) do
      delete :destroy, id: @on_winning
    end

    assert_redirected_to on_winnings_path
  end
end
