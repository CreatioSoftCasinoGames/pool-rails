require 'test_helper'

class ClientBugsControllerTest < ActionController::TestCase
  setup do
    @client_bug = client_bugs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:client_bugs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client_bug" do
    assert_difference('ClientBug.count') do
      post :create, client_bug: { bug_type: @client_bug.bug_type, exception: @client_bug.exception }
    end

    assert_redirected_to client_bug_path(assigns(:client_bug))
  end

  test "should show client_bug" do
    get :show, id: @client_bug
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client_bug
    assert_response :success
  end

  test "should update client_bug" do
    patch :update, id: @client_bug, client_bug: { bug_type: @client_bug.bug_type, exception: @client_bug.exception }
    assert_redirected_to client_bug_path(assigns(:client_bug))
  end

  test "should destroy client_bug" do
    assert_difference('ClientBug.count', -1) do
      delete :destroy, id: @client_bug
    end

    assert_redirected_to client_bugs_path
  end
end
