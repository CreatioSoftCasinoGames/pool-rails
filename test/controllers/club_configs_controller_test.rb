require 'test_helper'

class ClubConfigsControllerTest < ActionController::TestCase
  setup do
    @club_config = club_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:club_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create club_config" do
    assert_difference('ClubConfig.count') do
      post :create, club_config: { entry_fees: @club_config.entry_fees, name: @club_config.name, winner_amount: @club_config.winner_amount }
    end

    assert_redirected_to club_config_path(assigns(:club_config))
  end

  test "should show club_config" do
    get :show, id: @club_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @club_config
    assert_response :success
  end

  test "should update club_config" do
    patch :update, id: @club_config, club_config: { entry_fees: @club_config.entry_fees, name: @club_config.name, winner_amount: @club_config.winner_amount }
    assert_redirected_to club_config_path(assigns(:club_config))
  end

  test "should destroy club_config" do
    assert_difference('ClubConfig.count', -1) do
      delete :destroy, id: @club_config
    end

    assert_redirected_to club_configs_path
  end
end
