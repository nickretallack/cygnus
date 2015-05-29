require 'test_helper'

class PoolsControllerTest < ActionController::TestCase
  setup do
    @pool = pools(:poolone)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pools)
  end

  test "should get new" do
    @controller.log_in(@pool.user)
    get :new
    assert_response :success
  end

  test "should create pool" do
    assert_difference('Pool.count') do
      post :create, pool: { title: @pool.title, user_id: @pool.user_id }
    end

    assert_redirected_to pool_path(assigns(:pool))
  end

  test "should show pool" do
    get :show, id: @pool
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pool
    assert_response :success
  end

  test "should update pool" do
    patch :update, id: @pool, pool: { title: @pool.title, user_id: @pool.user_id }
    assert_redirected_to pool_path(assigns(:pool))
  end

  test "should destroy pool" do
    assert_difference('Pool.count', -1) do
      delete :destroy, id: @pool
    end

    assert_redirected_to pools_path
  end
end
