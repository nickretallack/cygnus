require 'test_helper'

class MinersControllerTest < ActionController::TestCase
  setup do
    @miner = miners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:miners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create miner" do
    assert_difference('Miner.count') do
      post :create, miner: { miner: @miner.miner }
    end

    assert_redirected_to miner_path(assigns(:miner))
  end

  test "should show miner" do
    get :show, id: @miner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @miner
    assert_response :success
  end

  test "should update miner" do
    patch :update, id: @miner, miner: { miner: @miner.miner }
    assert_redirected_to miner_path(assigns(:miner))
  end

  test "should destroy miner" do
    assert_difference('Miner.count', -1) do
      delete :destroy, id: @miner
    end

    assert_redirected_to miners_path
  end
end
