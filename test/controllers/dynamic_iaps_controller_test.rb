require 'test_helper'

class DynamicIapsControllerTest < ActionController::TestCase
  setup do
    @dynamic_iap = dynamic_iaps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dynamic_iaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dynamic_iap" do
    assert_difference('DynamicIap.count') do
      post :create, dynamic_iap: { country: @dynamic_iap.country, currency: @dynamic_iap.currency, iap_id: @dynamic_iap.iap_id, new_coins_value: @dynamic_iap.new_coins_value, new_pricing: @dynamic_iap.new_pricing, offer: @dynamic_iap.offer, old_coins_value: @dynamic_iap.old_coins_value, old_pricing: @dynamic_iap.old_pricing }
    end

    assert_redirected_to dynamic_iap_path(assigns(:dynamic_iap))
  end

  test "should show dynamic_iap" do
    get :show, id: @dynamic_iap
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dynamic_iap
    assert_response :success
  end

  test "should update dynamic_iap" do
    patch :update, id: @dynamic_iap, dynamic_iap: { country: @dynamic_iap.country, currency: @dynamic_iap.currency, iap_id: @dynamic_iap.iap_id, new_coins_value: @dynamic_iap.new_coins_value, new_pricing: @dynamic_iap.new_pricing, offer: @dynamic_iap.offer, old_coins_value: @dynamic_iap.old_coins_value, old_pricing: @dynamic_iap.old_pricing }
    assert_redirected_to dynamic_iap_path(assigns(:dynamic_iap))
  end

  test "should destroy dynamic_iap" do
    assert_difference('DynamicIap.count', -1) do
      delete :destroy, id: @dynamic_iap
    end

    assert_redirected_to dynamic_iaps_path
  end
end
