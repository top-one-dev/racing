require 'test_helper'

class StagesControllerTest < ActionController::TestCase
  setup do
    @stage = stages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stage" do
    assert_difference('Stage.count') do
      post :create, stage: { active_date: @stage.active_date, close_date: @stage.close_date, name: @stage.name, race_id: @stage.race_id }
    end

    assert_redirected_to stage_path(assigns(:stage))
  end

  test "should show stage" do
    get :show, id: @stage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stage
    assert_response :success
  end

  test "should update stage" do
    patch :update, id: @stage, stage: { active_date: @stage.active_date, close_date: @stage.close_date, name: @stage.name, race_id: @stage.race_id }
    assert_redirected_to stage_path(assigns(:stage))
  end

  test "should destroy stage" do
    assert_difference('Stage.count', -1) do
      delete :destroy, id: @stage
    end

    assert_redirected_to stages_path
  end
end
