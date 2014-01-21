require 'test_helper'

class AmbulancesControllerTest < ActionController::TestCase
  setup do
    @ambulance = ambulances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ambulances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ambulance" do
    assert_difference('Ambulance.count') do
      post :create, ambulance: {  }
    end

    assert_redirected_to ambulance_path(assigns(:ambulance))
  end

  test "should show ambulance" do
    get :show, id: @ambulance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ambulance
    assert_response :success
  end

  test "should update ambulance" do
    patch :update, id: @ambulance, ambulance: {  }
    assert_redirected_to ambulance_path(assigns(:ambulance))
  end

  test "should destroy ambulance" do
    assert_difference('Ambulance.count', -1) do
      delete :destroy, id: @ambulance
    end

    assert_redirected_to ambulances_path
  end
end
