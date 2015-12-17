require 'test_helper'

class RostersControllerTest < ActionController::TestCase
  setup do
    @roster = rosters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rosters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roster" do
    assert_difference('Roster.count') do
      post :create, roster: { join_date: @roster.join_date }
    end

    assert_redirected_to roster_path(assigns(:roster))
  end

  test "should show roster" do
    get :show, id: @roster
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roster
    assert_response :success
  end

  test "should update roster" do
    patch :update, id: @roster, roster: { join_date: @roster.join_date }
    assert_redirected_to roster_path(assigns(:roster))
  end

  test "should destroy roster" do
    assert_difference('Roster.count', -1) do
      delete :destroy, id: @roster
    end

    assert_redirected_to rosters_path
  end
end
